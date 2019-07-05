<?php
namespace CrearyDB\Helpers;

use Phalcon\Tag;

class Reputation extends Tag
{
  static public function number($rep)
  {
      if (is_numeric($rep)) {
          $maxLevel = 8;
          $maxLogNum = 20;

          $rep = floatval($rep);
          $logRep = log10($rep);
          $logRep = $logRep * $maxLevel / $maxLogNum;
          $buzz = round($logRep * 10);
          return intval($buzz);
      }

    return 0;
  }
}
