import React from 'react'
import { HashRouter, Routes as Switch, Route } from 'react-router-dom'
import People from './people/component'

const routes = [
  { key: 1, exact: true, index: true,  path: '/', element: <People/> },
];


const Routes = () => (
  <HashRouter>
    <Switch>
      {routes.map(todo => (
        <Route {...todo} />
      ))}
    </Switch>
  </HashRouter>
);

export default Routes;
