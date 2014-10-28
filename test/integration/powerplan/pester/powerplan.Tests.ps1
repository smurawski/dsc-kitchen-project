describe 'Powerplan' {
  it 'should be high performance' {
    (Get-CimInstance win32_powerplan -Namespace root/cimv2/power -filter 'IsActive = "True"').ElementName | should be 'High performance'
  }
}