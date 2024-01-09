import { BrowserRouter, Route, Routes } from "react-router-dom"
import HomePage from "./pages/HomePage"
import NFTPage from "./pages/NFTPage"
import "./App.css"

function App() {
  return (
	<div className="background">
	<BrowserRouter>
  	<Routes>
    	<Route path="/" Component={HomePage} />
      <Route path="/:id" Component={NFTPage} />
  	</Routes>
	</BrowserRouter>
	</div>
  )
}

export default App

