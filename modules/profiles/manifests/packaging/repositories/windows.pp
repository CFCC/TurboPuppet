#
# Windows package repositories
#
class profiles::packaging::repositories::windows {
  # Some day...
  #include profiles::packaging::repositories::windows::system
  #include profiles::packaging::repositories::windows::thirdparty
  include profiles::packaging::repositories::windows::collections

  # Normally I'd say realize only the system category here and leave the rest to their
  # specific profiles. However, since we don't require that level of separation yet, they
  # will all be here and it can be assumed that any needed yum repo by any profile
  # will have that repo available.
  Chocolateysource <| tag == 'chocolateysource-system' |>
  Chocolateysource <| tag == 'chocolateysource-collections' |>
  Chocolateysource <| tag == 'chocolateysource-thirdparty' |>

  Psrepository <| tag == 'psrepository-system' |>
  Psrepository <| tag == 'psrepository-collections' |>
  Psrepository <| tag == 'psrepository-thirdparty' |>

  # Remove any resources that we don't manage.
  resources { ['chocolateysource', 'psrepository']:
    purge => true,
  }
}
