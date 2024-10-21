import React, { useState, useEffect, useRef, useCallback } from "react";
import { Box, Text, Loader, Flex } from "@mantine/core";
import { CiSquareCheck } from "react-icons/ci";
import { MdOutlineCancelPresentation } from "react-icons/md";
import styles from "./Notification.module.scss";

interface NotificationData {
  id: string;
  title?: string;
  message: string;
  icon?: "success" | "error" | "progress" | "line";
  duration?: number;
  position?: "top-left" | "top-right" | "bottom-left" | "bottom-right";
}

const NotificationComponent: React.FC = () => {
  const [notifications, setNotifications] = useState<NotificationData[]>([]);
  const [visibleNotifications, setVisibleNotifications] = useState<Set<string>>(
    new Set()
  );
  const [removingNotifications, setRemovingNotifications] = useState<
    Set<string>
  >(new Set());
  const timers = useRef<Record<string, NodeJS.Timeout>>({});

  const showNotification = (notification: Omit<NotificationData, "id">) => {
    const id = `notif-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
    const newNotification = { ...notification, id };

    setNotifications((prevNotifications) => [
      ...prevNotifications,
      newNotification,
    ]);
    setVisibleNotifications((prev) => new Set(prev).add(id));

    if (newNotification.duration) {
      timers.current[id] = setTimeout(() => {
        setRemovingNotifications((prev) => new Set(prev).add(id));
        setTimeout(() => removeNotification(id), 500);
      }, newNotification.duration);
    }
  };

  // useEffect(() => {

  //   window.postMessage({
  //     action: "SendNotification",
  //     id: "notif-success",
  //     title: "Success",
  //     message: "Your changes have been saved successfully!",
  //     icon: "success",
  //     duration: 10000000,
  //     position: "top-right",
  //   });


  //     window.postMessage({
  //       action: "SendNotification",
  //       id: "notif-error",
  //       title: "Error",
  //       message: "Failed to save changes. Please try again.",
  //       icon: "error",
  //       duration: 10000000,
  //       position: "top-left",
  //     });


  //     window.postMessage({
  //       action: "SendNotification",
  //       id: "notif-progress",
  //       title: "Processing",
  //       message: "Your request is being processed.",
  //       icon: "progress",
  //       duration: 10000000,
  //       position: "bottom-right",
  //     });

  //     window.postMessage({
  //       action: "SendNotification",
  //       id: "notif-warning",
  //       title: "Warning",
  //       message: "Your session is about to expire.",
  //       icon: "line",
  //       duration: 10000000,
  //       position: "bottom-left",
  //     });



  //     window.postMessage({
  //       action: "SendNotification",
  //       id: "notif-info",
  //       title: "Information",
  //       message: "New update available.",
  //       icon: "line",
  //       duration: 10000000,
  //       position: "top-right",
  //     });

  // }, []);

  const removeNotification = (idToRemove: string) => {
    setNotifications((prevNotifications) =>
      prevNotifications.filter((notification) => notification.id !== idToRemove)
    );
    setVisibleNotifications((prev) => {
      const updated = new Set(prev);
      updated.delete(idToRemove);
      return updated;
    });
    setRemovingNotifications((prev) => {
      const updated = new Set(prev);
      updated.delete(idToRemove);
      return updated;
    });
  };

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data.action === "SendNotification") {
        showNotification(data);
      }
    };

    window.addEventListener("message", handleMessage);
    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, []);

  const getFlexStyle = useCallback((position: string): React.CSSProperties => {
    switch (position) {
      case "top-left":
        return { top: "10px", left: "10px" };
      case "top-right":
        return { top: "10px", right: "10px" };
      case "bottom-left":
        return { bottom: "10px", left: "10px" };
      case "bottom-right":
        return { bottom: "10px", right: "10px" };
      default:
        return {};
    }
  }, []);

  return (
    <div className={styles.container}>
      {["top-left", "top-right", "bottom-left", "bottom-right"].map(
        (position) => {
          const notificationsForPosition = notifications.filter(
            (n) => n.position === position
          );
          return (
            <Flex
              key={position}
              direction="column"
              align={position.includes("right") ? "flex-end" : "flex-start"}
              style={{ position: "absolute", ...getFlexStyle(position) }}
            >
              {notificationsForPosition.map((notification) => (
                <Box
                  key={notification.id}
                  className={`${styles.notification}
                  ${
                    visibleNotifications.has(notification.id)
                      ? styles["slide-in"]
                      : ""
                  }
                  ${
                    removingNotifications.has(notification.id)
                      ? styles["slide-out"]
                      : ""
                  }`}
                  onAnimationEnd={() => {
                    if (removingNotifications.has(notification.id)) {
                      removeNotification(notification.id);
                    }
                  }}
                >
                  {notification.icon === "progress" ? (
                    <Loader
                      size="sm"
                      color="violet"
                      style={{ marginRight: 12 }}
                    />
                  ) : notification.icon === "success" ? (
                    <div style={{ marginRight: 12 }}>
                      <CiSquareCheck size="2.0rem" color="#12b886" />
                    </div>
                  ) : notification.icon === "error" ? (
                    <div style={{ marginRight: 12 }}>
                      <MdOutlineCancelPresentation
                        size="2.0rem"
                        color="#f03e3e"
                      />
                    </div>
                  ) : notification.icon === "line" ? (
                    <div
                      style={{
                        width: "1px",
                        height: "34px",
                        backgroundColor: "#fd7e14",
                        marginRight: 12,
                        borderRadius: "4px",
                        boxShadow: "0 2px 4px rgba(0, 0, 0, 0.2)",
                      }}
                    />
                  ) : null}
                  <div>
                    {notification.title && (
                      <Text fw={500} tt="uppercase">
                        {notification.title}
                      </Text>
                    )}
                    <Text fz="md">{notification.message}</Text>
                  </div>
                </Box>
              ))}
            </Flex>
          );
        }
      )}
    </div>
  );
};

export default NotificationComponent;
