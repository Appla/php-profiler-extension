--TEST--
Tideways: Exclude userland functions from profilling
--FILE--
<?php

include_once dirname(__FILE__).'/common.php';

function foo($x) {
    return bar($x);
}
function bar($x) {
    return strlen($x);
}

tideways_enable(TIDEWAYS_FLAGS_NO_USERLAND);
foo("foo");
$data = tideways_disable();

print_canonical($data);
?>
--EXPECTF--
main()                                  : ct=       1; wt=*;
main()==>strlen                         : ct=       1; wt=*;
main()==>tideways_disable               : ct=       1; wt=*;
