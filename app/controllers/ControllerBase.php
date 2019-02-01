<?php
namespace CrearyDB\Controllers;

use Phalcon\Mvc\Controller;
use Phalcon\Mvc\Dispatcher;

class ControllerBase extends Controller
{

    /**
     * @var \Cread
     */
    protected $cread;

    /**
     * ControllerBase constructor.
     */
    public function __construct()
    {
        $this->cread = new \Cread('https://node1.creary.net');
    }


}