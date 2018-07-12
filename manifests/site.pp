# Site.pp is used for literally everything. Use with caution.

# The PS expression "('Foo' -eq 'Foo')" returns True. Conversely, 
# "('Foo' -ne 'Foo')" returns False. When cast to an integer
# (prefix the expression with [int]) this gets a bit more fun.
# False -> 0, True -> 1. However when running simply that
# expression in a PS shell the return code is always 0 (success).
# The return value (0, 1) is what we actually care about.
#
# The Puppet onlyif argument will allow an exec{} to run only when
# a test command returns 0. We can use the 'exit' command
# to have the PS interpreter take our return value and use
# that as the exit code instead. This gets us a return code
# pattern of:
# False/0 -> 0
# True/1  -> 1
#
# This now gets confusing. If we look at a sample test command
# of "exit [int]('Foo' -eq 'Foo')", this returns 1 (True). Except
# when read in the context of onlyif, the logic reads as:
#   "Run my command only if 'Foo' equals 'Foo'.
#
# Which doesn't exactly jive if the command is to say set a
# property or something. A la
#   "Set a network to Private only if the network is currently Private"
# That's a bit backwards. In this case I want the command to set only
# if the network is currently NOT Private. Something like:
#   "Set network to Private only if network is currently NOT private"
# But when we evaluate "exit [int]('Private' -ne 'Private')"
# we get False/0, which the test believe is success so the command runs.
# Similarly "exit [int]('Foobar' -ne 'Private')" is True/1 which the test
# belives failed so it does not trigger the command to run.
#
# It'd be really hot if we can invert the meaning of 0 and 1 in Puppet's
# return interpretation but alas we cannot. So can we do that in
# Powershell? Yes! RC=0 always evaluates to Success (aka run the command)
# and any other value will evaluate to fail (aka don't run the command).
# So we if subtract 1 from our return codes we get:
# False/0 -> -1
# True/1  -> 0
# In an expression this looks like "exit [int]('Foo' -ne 'Foo') - 1".
# It's kinda gross, but it works.
function psexpr(String $input) >> String {
    $expression = "exit [int](${input}) - 1"

    # Return
    $expression
}

# This resource will create HKCU registry entries. You can't use the regular
# registry_key and registry_value resources because you don't necessarily control
# who the current user is. In our case, we do.
define hkcu(
    $key,
    $value,
    $data,
) {
    $formatted_key = "HKCU:${key}"

    # Test-Path returns False if nonexistant, True if existant
    exec { "Create-${name}":
        command => "New-Item -Path ${formatted_key}",
        unless  => psexpr("Test-Path -Path ${formatted_key}")
    }

    exec { "Set-${name}":
        command => "Set-ItemProperty -Path ${formatted_key} -Name ${value} ${data}",
        onlyif  => psexpr("(Get-ItemProperty -Path ${formatted_key} -Name ${value} | Select -ExpandProperty ${value}) -ne ${data}"),
    }

    Exec["Create-${name}"] -> Exec["Set-${name}"]
}