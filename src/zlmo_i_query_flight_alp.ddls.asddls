@AbapCatalog.sqlViewName: 'ZLMOVQFLIGHTALP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight (Analytical List Page)'

@Analytics.query: true // Transformar a CDS View em uma consulta analítica e utilizar o poder de agregação
@VDM.viewType: #CONSUMPTION
@OData.publish: true

@UI.selectionPresentationVariant: [{
    qualifier: 'KPIWeightByCountry',
    presentationVariantQualifier: 'KPIWeightByCountry',
    selectionVariantQualifier: 'KPIWeightByCountry'
    },{
    qualifier: 'Default',
    presentationVariantQualifier: 'Default',
    selectionVariantQualifier: 'Default'
}]

@UI.presentationVariant: [{
    qualifier: 'KPIWeightByCountry',
    text: 'KPI: Weight of Luggage per Country',
    visualizations: [{
        type: #AS_CHART,
        qualifier: 'ChartWeightByCountry'
        },{
        type: #AS_DATAPOINT,
        qualifier: 'WeightOfLuggage'
    }]
    },{
    qualifier: 'FilterBookingsByYear',
    text: 'Filter: Bookings by Year',
    visualizations: [{
        type: #AS_CHART,
        qualifier: 'ChartBookingsByYear'
    }]
    },{
    qualifier: 'Default',
    visualizations: [{
        type: #AS_CHART,
        qualifier: 'ChartDefault'
    }]
}]

@UI.selectionVariant: [{
    qualifier: 'KPIWeightByCountry',
    text: 'Default'
    },{
    qualifier: 'Default',
    text: 'Default'
}]

@UI.chart: [{
    qualifier: 'ChartWeightByCountry',
    chartType: #COLUMN,
    dimensions: [ 'CustomerCountry' ],
    measures: [ 'WeightOfLuggage' ],
    dimensionAttributes: [{
        dimension: 'CustomerCountry',
        role: #CATEGORY
    }],
    measureAttributes: [{
        measure: 'WeightOfLuggage',
        role: #AXIS_1
    }]
    },{
    qualifier: 'ChartBookingsByYear',
    chartType: #DONUT,
    dimensions: [ 'CalendarYear' ],
    measures: [ 'TotalOfBookings' ],
    dimensionAttributes: [{
        dimension: 'CalendarYear',
        role: #CATEGORY
    }],
    measureAttributes: [{
        measure: 'TotalOfBookings',
        role: #AXIS_1
    }]
    },{
    qualifier: 'ChartDefault',
    chartType: #COLUMN,
    dimensions: [ 'CalendarYear', 'Airline' ],
    measures: [ 'TotalOfBookings' ],
    dimensionAttributes: [{
        dimension: 'CalendarYear',
        role: #SERIES
    },{
        dimension: 'Airline',
        role: #CATEGORY
    }],
    measureAttributes: [{
        measure: 'TotalOfBookings',
        role: #AXIS_1
    }]
}]
define view ZLMO_I_QUERY_FLIGHT_ALP
  as select from ZLMO_I_CUBE_FLIGHTBOOK
{
  @AnalyticsDetails.query.display: #KEY_TEXT
  @UI.lineItem.position: 10
  Airline,
  @AnalyticsDetails.query.display: #KEY_TEXT
  CustomerCountry,
  @UI.selectionField.position: 10
  CalendarYear,
  @UI.lineItem.position: 20
  TotalOfBookings,
  @UI.dataPoint.title: 'Weight of Luggage'
  @UI.lineItem.position: 30
  WeightOfLuggage
}
