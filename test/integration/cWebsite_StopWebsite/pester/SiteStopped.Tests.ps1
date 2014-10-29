describe 'When using the cWebAdministration resources' {
  context 'to stop the default website' {
    it 'sets the default site to stopped'{
      (Get-Website 'Default Web Site').State | should be 'stopped'
    }
  }
}