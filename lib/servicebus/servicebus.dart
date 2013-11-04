// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of servicebus;

abstract class bus_type extends typeenum
{
  static final bt_stack stack=const bt_stack();
  static final bt_queue queue=const bt_queue();
  static final typelist types=new typelist({bt_queue.symbol:bus_type.queue
                                            ,bt_stack.symbol:bus_type.stack});
  static final String classpath='/base/typeenum/bus_type';
  static const String symbol='bus.type';
  String get enumname => symbol;
  const bus_type.ctor():super.ctor();
}

class bt_stack extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_stack';
  static const String symbol='stack';
  String get typename => symbol;
  dynamic get toobject => 0x00000001;
  const bt_stack():super.ctor();
}

class bt_queue extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_queue';
  static const String symbol='queue';
  String get typename => symbol;
  dynamic get toobject => 0x00000002;
  const bt_queue():super.ctor();
}


abstract class service_nodes extends typeenum
{
  static const sn_single single=const sn_single();
  static const sn_multiple multiple=const sn_multiple();
  static final typelist types=new typelist({sn_single.symbol:service_nodes.single
                                            ,sn_multiple.symbol:service_nodes.multiple});
  static final String classpath='/base/typeenum/service_nodes';
  static const String symbol='service.nodes';
  String get enumname => symbol;
  const service_nodes.ctor():super.ctor();

}

class sn_single extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_single';
  static const String symbol='single';
  String get typename => symbol;
  dynamic get toobject => 0x00000001;
  const sn_single():super.ctor();
}

class sn_multiple extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_multiple';
  static const String symbol='multiple';
  String get typename => symbol;
  dynamic get toobject => 0x00000002;
  const sn_multiple():super.ctor();
}

