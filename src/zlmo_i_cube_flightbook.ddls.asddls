@AbapCatalog.sqlViewName: 'ZLMOV_CBFLIBOOK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Bookings'
@Analytics.dataCategory: #CUBE
define view ZLMO_I_CUBE_FLIGHTBOOK
  as select from sbook
  association [0..1] to I_CalendarDate              as _CalendarDate on  $projection.FlightDate = _CalendarDate.CalendarDate
  association [0..1] to ZMAC_I_DIMENSION_AIRLINE    as _Airline      on  $projection.Airline = _Airline.Airline
  association [0..1] to ZMAC_I_DIMENSION_CONNECTION as _Connection   on  $projection.Airline          = _Connection.Airline
                                                                     and $projection.FlightConnection = _Connection.FlightConnection
  association [0..1] to ZMAC_I_DIMENSION_CUSTOMER   as _Customer     on  $projection.Customer = _Customer.Customer
  association [0..1] to ZMAC_I_DIMENSION_TR_AGENCY  as _TravelAgency on  $projection.TravelAgency = _TravelAgency.TravelAgency
{
  /** DIMENSIONS **/
  @EndUserText.label: 'Airline'
  @ObjectModel.foreignKey.association: '_Airline'
  carrid                 as Airline,
  @EndUserText.label: 'Connection'
  @ObjectModel.foreignKey.association: '_Connection'
  connid                 as FlightConnection,
  @EndUserText.label: 'Flight Date'
  @ObjectModel.foreignKey.association: '_CalendarDate'
  fldate                 as FlightDate,
  @EndUserText.label: 'Book No.'
  bookid                 as BookNumber,
  @EndUserText.label: 'Customer'
  @ObjectModel.foreignKey.association: '_Customer'
  customid               as Customer,
  @EndUserText.label: 'Travel Agency'
  @ObjectModel.foreignKey.association: '_TravelAgency'
  agencynum              as TravelAgency,
  @EndUserText.label: 'Flight Year'
  _CalendarDate.CalendarYear,
  @EndUserText.label: 'Flight Month'
  _CalendarDate.CalendarMonth,
  @EndUserText.label: 'Customer Country'
  @ObjectModel.foreignKey.association: '_CustomerCountry'
  _Customer.Country      as CustomerCountry,
  @EndUserText.label: 'Customer City'
  _Customer.City         as CustomerCity,
  @EndUserText.label: 'Travel Agency Country'
  @ObjectModel.foreignKey.association: '_TravelAgencyCountry'
  _TravelAgency.Country  as TravelAgencyCountry,
  @EndUserText.label: 'Travel Agency Customer City'
  _TravelAgency.City     as TravelAgencyCity,
  
  /** MEASURES **/
  @EndUserText.label: 'Total of Bookings'
  @DefaultAggregation: #SUM
  1                      as TotalOfBookings,
  @EndUserText.label: 'Weight of Luggage'
  @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'WeightUOM'
  luggweight             as WeightOfLuggage,
  @EndUserText.label: 'Weight Unit'
  @Semantics.unitOfMeasure: true
  wunit                  as WeightUOM,
  @EndUserText.label: 'Booking Price'
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'Currency'
  forcuram               as BookingPrice,
  @EndUserText.label: 'Currency'
  @Semantics.currencyCode: true
  forcurkey              as Currency,
  
  // Associations
  _Airline,
  _CalendarDate,
  _CalendarDate._CalendarMonth,
  _CalendarDate._CalendarYear,
  _Connection,
  _Customer,
  _Customer._Country     as _CustomerCountry,
  _TravelAgency,
  _TravelAgency._Country as _TravelAgencyCountry
}
