Future<void> fetchData() async {
  print("Fetching Data ...");
  Future.delayed(Duration(seconds: 3));
  print("Data Fetched");
}

void main() {
  print("Start");
  fetchData();
  print("END");
  print("This is Main Execution");
}
