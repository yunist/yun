// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * all base classes of the yun framework. and a top-level function to create instance by name
 *
 */

library yun;

import "dart:isolate";
import "dart:mirrors";
//import "package:json/json.dart" as json;

part "message.dart";
part "service.dart";
part "messagevmrouter.dart";
part "messagevmnode.dart";
part "isolatepool.dart";
part "systembuilder.dart";

/// root route table
List rootrouters=[];

/// main receive port
ReceivePort receiveport;

/**
 * a base interface of yun.
 */
class ibase
{
  static final String classpath='/ibase';
}

/**
 * a base class of yun.
 */
class base implements ibase
{
  static final String classpath='/base';
  const base.ctor();
  base();
}

/**
 * a data class. should to implement serialization using mirrorsystem
 */
class data extends base
{
  static final String classpath='/base/data';
  const data.ctor():super.ctor();
  data();
}

/**
 * repleace list to inherit from yun base
 */
class collection<T> extends data
{
  static final String classpath='/base/data/collection';
  List items;
  dynamic remove_first()
  {
    return items.removeAt(0);
  }
  dynamic remove_last()
  {
    return items.removeLast();
  }
  void add_last(dynamic item)
  {
    items.add(item);
  }

  dynamic operator[](dynamic key)
  {
    return items[key];
  }

  void operator[]=(dynamic key,T value)
  {
    items[key]=value;
  }
}

/**
 * repleace map to inherit from yun base
 */
class dictionary<Tkey,Tvalue> extends data
{
  static final String classpath='/base/data/dictionary';
  Map<Tkey,Tvalue> items;

  dictionary([Map<Tkey,Tvalue> this.items]){}

  Tvalue operator[](Tkey key)
  {
    return items[key];
  }

  void operator[]=(Tkey key,Tvalue value)
  {
    items[key]=value;
  }

  Tvalue remove(Tkey key)
  {
    return items.remove(key);
  }
}

/**
 * queue
 */
class queue<T> extends collection<T>
{
  static final String classpath='/base/data/collection/queue';
  T dequeue()
  {
    return remove_first();
  }
  void enqueue(T item)
  {
    add_last(item);
  }
}

/**
 * stack
 */
class stack<T> extends collection<T>
{
  static final String classpath='/base/data/collection/stack';
  T pop()
  {
    return remove_last();
  }
  void push(T item)
  {
    add_last(item);
  }
}

/**
 * class-based enumerated type
 */
abstract class typeenum extends data
{
  static final String classpath='/base/data/typeenum';
  String get typename;
  String get enumname;
  dynamic get toobject;
  const typeenum.ctor():super.ctor();
}

/**
 * class-based enumerated type collection
 */
class typelist extends dictionary<String,typeenum>
{
  static final String classpath='/base/data/collection/typelist';
  typelist([Map<String,typeenum> list]):super(list){}
}

/**
 * top-level function to create instance from class name
 */
dynamic CreateInstance(Symbol libraryname,Symbol classname,List arguments)
{
  MirrorSystem mirrors = currentMirrorSystem();
  dynamic lf = mirrors.findLibrary(libraryname);
  if (lf!=null)
    lf.forEach((LibraryMirror lm)
    {
      ClassMirror cm = lm.classes[classname];
      if (cm!=null)
      {
        InstanceMirror im = cm.newInstance(const Symbol(''), arguments);
        return im.reflectee;
      }
    });
  return null;
}