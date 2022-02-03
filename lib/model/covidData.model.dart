final String covidDataTable = 'covidDataTable';

class covidDataField {
  static final String id = "_id";
  static final String total_cases = "total_cases";
  static final String deaths = "deaths";
  static final String recovered = "recovered";
  static final String active = "active";
  static final String critical = "critical";

}

class covidData {
  final int id;
  final String total_cases;
  final String deaths;
  final String recovered;
  final String active;
  final String critical;

  covidData(
      this.id,
      this.total_cases,
      this.deaths,
      this.recovered,
      this.active,
      this.critical);

  Map<String, Object> toJson() => {
    covidDataField.id: id,
    covidDataField.total_cases: total_cases,
    covidDataField.deaths: deaths,
    covidDataField.recovered: recovered,
    covidDataField.active: active,
    covidDataField.critical: critical,

  };
  covidData copy({
    int id,
    String total_cases,
    String deaths,
    String recovered,
    String active,
    String critical
  }) => covidData(id, total_cases, deaths, recovered, active, critical);
}

