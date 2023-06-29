class ApiResponse<T> {
  T data;
  bool error;
  late String errorMessage;
  ApiResponse(
       this.data,
      this.error,
      this.errorMessage);
}