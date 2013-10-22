// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of servicebus;

abstract class bus_type extends typeenum
{
  static final String classpath='/base/typeenum/bus_type';
  String get enumname => 'bus.type';
}

class bt_stack extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_stack'; 
  String get typename => 'stack';
}

class bt_queue extends bus_type
{
  static final String classpath='/base/typeenum/bus_type/bt_stack'; 
  String get typename => 'queue';
}


abstract class service_nodes extends typeenum
{
  static final String classpath='/base/typeenum/service_nodes';   
  String get enumname => 'service.nodes';
}

class sn_single extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_single'; 
  String get typename => 'single';
}

class sn_multiple extends service_nodes
{
  static final String classpath='/base/typeenum/service_nodes/sn_multiple'; 
  String get typename => 'multiple';
}

