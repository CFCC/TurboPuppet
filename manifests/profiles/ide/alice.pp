#
# Alice
#
class profiles::ide::alice {
    # GAH! PACKAGE NAMES
    package { 'Alice 3 3.4.0.0+build123':
        provider        => windows,
        source          => "${::profiles::site::cfcc::nas_installers_path}\Alice3_windows-x64_3_4_0_0.exe",
        install_options => ['-q']
    }
}