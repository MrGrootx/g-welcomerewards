import Router from "./providers/Router";
import { debugData } from "./utils/debugData";
import { SystemSettings } from "./types";
import { setSystemSettings } from "./store/Welcome-slice";
import { useDispatch } from "react-redux";
import { useNuiEvent } from "./hooks/useNuiEvent";

debugData([
  {
    action: "setVisibleApp",
    data: true,
  },
]);

debugData<SystemSettings>([
  {
    action: "justgroot:systemsettings:systemsettings",
    data: {
      Currency: "$",
      position: "center",
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
    </>
  );
};

export default ManageRender;
