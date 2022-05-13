#
# Windows package repositories
#
class profile::packaging::repositories::windows {

  # Some day...
  #include profile::packaging::repositories::windows::system
  #include profile::packaging::repositories::windows::thirdparty
  include profile::packaging::repositories::windows::collections

  # Normally I'd say realize only the system category here and leave the rest to their
  # specific profiles. However, since we don't require that level of separation yet, they
  # will all be here and it can be assumed that any needed yum repo by any profile
  # will have that repo available.
  #Chocolateysource <| tag == 'chocolateysource-system' |>
  Chocolateysource <| tag == 'chocolateysource-collections' |>
  #Chocolateysource <| tag == 'chocolateysource-thirdparty' |>

  # Remove any resources that we don't manage.
  resources { 'chocolateysource':
    purge => true,
  }
}
