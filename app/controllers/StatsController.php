<?php
namespace CrearyDB\Controllers;

use MongoDB\BSON\UTCDateTime;

use CrearyDB\Models\AuthorReward;
use CrearyDB\Models\CurationReward;

class StatsController extends ControllerBase
{

  public function indexAction()
  {
    $this->view->props = $props = $this->Cread->getProps();
    $this->view->totals = $totals = $this->util->distribution($props);
    var_dump($totals); exit;
  }

}
