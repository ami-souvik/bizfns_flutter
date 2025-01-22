
import 'package:equatable/equatable.dart';

import 'Status.dart';


class Resource<T> extends Equatable{
  STATUS status;
  T? data;
  String? message;

  Resource({required this.status, required this.data, required this.message});

  static Resource success({data}) => Resource(status: STATUS.SUCCESS, data: data, message: null);
  static Resource error({data,message}) => Resource(status: STATUS.ERROR, data: data, message: message);
  static Resource loading({data}) => Resource(status: STATUS.LOADING, data: data, message: null);


  @override
  String toString() {
    return 'Resource{status: $status, data: $data, message: $message}';
  }

  Resource copyWith({STATUS? status, T? data, String? messege}){
    return Resource(status: status??this.status,data: data??this.data,message: messege??this.message);
  }
  @override
  List<Object> get props => [status,data??"",message??""];
}

class Stack<T>extends Equatable {
  List<T> _stack = [];

  void push(T item) => _stack.add(item);

  T pop() => _stack.removeLast();
  @override
  List<Object> get props => [_stack];
}
