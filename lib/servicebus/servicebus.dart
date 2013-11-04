// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of servicebus;

abstract class bus_type extends typeenum
{
  static final bt_stack stack=const bt_stack();
  static final bt_queue queue=const bt_queue();
  static final typelist types=new typelist({bus_type.queue:bt_queue.classpath
                                            ,bus_type.stack:bt_stack.classpath});
  static final String classpath='/base/typeenum/bus_type';
  String get enumname => 'bus.type';
  const bus_type.ctor():super.ctor();
}

class bt_stack extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_stack';
  String get typename => 'stack';
  const bt_stack():super.ctor();
}

class bt_queue extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_queue';
  String get typename => 'queue';
  const bt_queue():super.ctor();
}


abstract class service_nodes extends typeenum
{
  static final String classpath='/base/typeenum/service_nodes';
  String get enumname => 'service.nodes';
  const service_nodes.ctor():super.ctor();
  static const single=const sn_single();
  static const multiple=const sn_multiple();
}

class sn_single extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_single';
  String get typename => 'single';
  const sn_single():super.ctor();
}

class sn_multiple extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_multiple';
  String get typename => 'multiple';
  const sn_multiple():super.ctor();
}

