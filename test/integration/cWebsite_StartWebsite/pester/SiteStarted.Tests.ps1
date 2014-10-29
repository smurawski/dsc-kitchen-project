describe 'When using the cWebAdministration resources' {
  context 'to start the default website' {
    it 'sets the default site to started' {
      (Get-Website 'Default Web Site').State | should be 'Started'
    }
    it 'should have a default index.html' {
      irm localhost | should match 'hi'
    }
  }
}