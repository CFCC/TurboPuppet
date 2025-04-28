class profiles::test {
  notice('Profile Test')
  notify { "Test value is: ${profiles::test::test_key}": }
}
