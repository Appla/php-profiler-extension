--TEST--
Tideways: Span Create/Get
--FILE--
<?php

$span = tideways_span_create('app');
$spans = tideways_get_spans();

var_dump($span);
var_dump($spans);

tideways_enable();

$span = tideways_span_create('php');
tideways_disable();

$spans = tideways_get_spans();

var_dump($span);
var_dump($spans);

tideways_enable();

$span = tideways_span_create('app');
tideways_disable();

$spans = tideways_get_spans();

var_dump($span);
var_dump($spans);

--EXPECTF--
NULL
NULL
int(1)
array(2) {
  [0]=>
  array(4) {
    ["n"]=>
    string(3) "app"
    ["b"]=>
    array(1) {
      [0]=>
      int(%d)
    }
    ["e"]=>
    array(1) {
      [0]=>
      int(%d)
    }
    ["a"]=>
    array(0) {
    }
  }
  [1]=>
  array(4) {
    ["n"]=>
    string(3) "php"
    ["b"]=>
    array(%d) {
    }
    ["e"]=>
    array(%d) {
    }
    ["a"]=>
    array(0) {
    }
  }
}
int(1)
array(2) {
  [0]=>
  array(4) {
    ["n"]=>
    string(3) "app"
    ["b"]=>
    array(1) {
      [0]=>
      int(%d)
    }
    ["e"]=>
    array(1) {
      [0]=>
      int(%d)
    }
    ["a"]=>
    array(0) {
    }
  }
  [1]=>
  array(4) {
    ["n"]=>
    string(3) "app"
    ["b"]=>
    array(%d) {
    }
    ["e"]=>
    array(%d) {
    }
    ["a"]=>
    array(0) {
    }
  }
}
