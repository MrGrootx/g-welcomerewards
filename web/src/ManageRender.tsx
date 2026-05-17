import Router from "./providers/Router";
import App3 from "./app/App3";
import { VisibilityProvider } from "./providers/VisibilityProvider";
import { debugData } from "./utils/debugData";
import App2 from "./app/App2";
import { SystemSettings } from "./types";
import { setSystemSettings } from "./store/Welcome-slice";
import { useDispatch } from "react-redux";
import { useNuiEvent } from "./hooks/useNuiEvent";

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
    action: "justgroot:systemsettings:systemsettings",
    data: {
      Currency: "$",
    },
  },
]);

const ManageRender = () => {
  const dispatch = useDispatch();
  useNuiEvent("justgroot:systemsettings:systemsettings", (data: SystemSettings) => {
    dispatch(setSystemSettings(data));
  });
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
