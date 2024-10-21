import React from "react";
import { Flex, Transition } from "@mantine/core";
import { IconMouse2 } from "@tabler/icons-react";
import "./Instruct.scss";

const Instructional: React.FC<{ visible: boolean; controls: any; schema: any }> = ({
  visible,
  controls,
  schema,
}) => {
  const { Styles } = schema || {};
  const { BackgroundColor, BackgroundBindColor, FontColor, Position , Animation  } = Styles || {};

  return (
    <Transition transition={Animation || "fade"} duration={500} mounted={visible}>
      {(styles) => (
        <Flex
          justify="center" 
          align={Position === "top" ? "flex-start" : "flex-end"}
          style={{
            position: "fixed",
            bottom: Position === "bottom" ? 20 : undefined,
            top: Position === "top" ? 20 : undefined,
            width: "100%",
            ...styles
          }} 
        >
          <div
            className="Instructional"
            style={{
              ...styles,
              backgroundColor: BackgroundColor || "rgba(20, 20, 20, 0.9)", 
              color: FontColor || "#c6c6c6", 
            }}
          >
            {Object.values(controls).map((control: any, index: number) => 
              control && (
                <div className="Instructional-message" key={index}>
                  <div
                    className="Instructional-bind"
                    style={{
                      backgroundColor: BackgroundBindColor || "rgba(54, 156, 129, 0.7)",
                    }}
                  >
                    {control.isMouse ? <IconMouse2 /> : control.key}
                  </div>
                  <div className="Instructional-message-container">
                    <div>{control.label}</div>
                    <div className="Instructional-description">
                      {control.description}
                    </div>
                  </div>
                </div>
              )
            )}
          </div>
        </Flex>
      )}
    </Transition>
  );
};

export default Instructional;
