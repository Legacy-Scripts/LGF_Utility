import React, { useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import ContextMenu from "./ContextMenu";
import NotificationComponent from "./Notification";
import TextUIComponent from "./TextUI";
import DialogComponent from "./Dialog"; 
import ProgressBar from "./ProgressBar";
import "./ContextMenu.scss";
import "./TextUI.scss";
import "./Dialog.scss";

const App: React.FC = () => {
  const [contextVisible, setContextVisible] = useState(false);
  const [currentMenuID, setCurrentMenuID] = useState<string | null>(null);

  useNuiEvent<{ visible: boolean; menuID: string }>(
    "CreateMenuContext",
    ({ visible, menuID }) => {
      setContextVisible(visible);
      setCurrentMenuID(menuID);
    }
  );

  const handleClose = () => {
    setContextVisible(false);
    if (!isEnvBrowser()) {
      fetchNui("ui:Close", {
        name: "CreateMenuContext",
        menuID: currentMenuID,
      });
    }
  };

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (contextVisible && e.code === "Escape") {
        handleClose();
      }
    };

    window.addEventListener("keydown", keyHandler);
    return () => {
      window.removeEventListener("keydown", keyHandler);
    };
  }, [contextVisible]);

  return (
    <>
      {currentMenuID && (
        <ContextMenu
          visible={contextVisible}
          menuID={currentMenuID}
          onClose={handleClose}
        />
      )}
      <NotificationComponent /> 
      <TextUIComponent /> 
      <DialogComponent /> 
      <ProgressBar /> 
    </>
  );
};

export default App;
