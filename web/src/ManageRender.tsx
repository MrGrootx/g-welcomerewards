import Router from "./providers/Router";
import App3 from "./app/App3";
import { VisibilityProvider } from "./providers/VisibilityProvider";
import { debugData } from "./utils/debugData";
import App2 from "./app/App2";
import { SystemSettings, WelcomeVehicle } from "./types";
import { MockVehicles } from "./data/MockItems";

debugData([
  {
    action: "setVisibleApp",
    data: true,
  },
  {
    action: "setVisibleApp2",
    data: false,
  },
  {
    action: "setVisibleApp3",
    data: false,
  },
]);

debugData<SystemSettings>([
  {
    action: "setSystemSettings",
    data: {
      Currency: "$",
    },
  },
]);

const ManageRender = () => {
  return (
    <>
      <Router />
      <VisibilityProvider component="App2">
        <App2 />
      </VisibilityProvider>
      <VisibilityProvider component="App3">
        <App3 />
      </VisibilityProvider>
    </>
  );
};

export default ManageRender;
