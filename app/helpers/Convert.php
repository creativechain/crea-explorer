<?php
namespace CrearyDB\Helpers;

use Phalcon\Tag;

class Convert extends Tag
{

  static private function getCache() {
    return static::getDI()->getShared('memcached');
  }

  static private function getProps() {
    return static::getDI()->getShared('Cread')->getProps();
  }

  static public function getConversionRate($key) {
    $cache = static::getCache();
    $cached = $cache->get($key);
    if($cached === null) {
      $props = static::getProps();
      $values = array(
        'total_vests' => (float) $props['total_vesting_shares'],
        'total_vest_crea' => (float) $props['total_vesting_fund_crea'],
      );
      $cache->save($key, $values);
      return $values;
    }
    return $cached;
  }

  static public function vest2cgy($value, $label = ' CGY', $round = 3)
  {
    $values = static::getConversionRate('convert_vest2cgy');
    $return = $values['total_vest_crea'] * ($value / $values['total_vests']);
    if($label === false) {
      return round($return, $round);
    }
    return number_format($return, $round, '.', ',') . $label;
  }

  static public function sp2vest($value, $label = ' VEST')
  {
    $values = static::getConversionRate('convert_vest2cgy');
    $return = (($value) / $values['total_vest_crea']) * $values['total_vests'];
    if($label === false) {
      return $return;
    }
    return number_format($return, 3, '.', ',') . $label;
  }
}
