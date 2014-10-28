configuration TestPowerPlan
{
  import-dscresource -modulename stackexchangeresources

  powerplan MakeItFast
  {
    Name = 'High performance'
  }
  
}

