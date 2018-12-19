String sourceFormat(String source) {
  String subSource = new RegExp(">([^<]*)<").stringMatch(source);

  subSource = subSource.substring(1, subSource.length - 2);
  return subSource;
}
