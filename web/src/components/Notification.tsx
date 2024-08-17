import React, { useState, useEffect, useRef, useCallback } from "react";
import styles from "./Notification.module.scss";
import { Box, Text, Loader } from "@mantine/core";
import { CiSquareCheck } from "react-icons/ci";
import { MdOutlineCancelPresentation } from "react-icons/md";

interface NotificationData {
  id: string;
  title?: string;
  message: string;
  icon?: "success" | "error" | "progress" | "line";
  duration?: number; // Duration in milliseconds
  position?: "top-left" | "top-right" | "bottom-left" | "bottom-right";
}

const NotificationComponent: React.FC = () => {
  const [notifications, setNotifications] = useState<NotificationData[]>([]);
  const [visibleNotifications, setVisibleNotifications] = useState<Set<string>>(new Set());
  const [removingNotifications, setRemovingNotifications] = useState<Set<string>>(new Set());
  const [notificationHeights, setNotificationHeights] = useState<Record<string, number>>({});
  const timers = useRef<Record<string, NodeJS.Timeout>>({});
  const notificationRefs = useRef<Record<string, HTMLDivElement>>({});

  const showNotification = (notification: Omit<NotificationData, "id">) => {
    const id = `notif-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
    const newNotification = { ...notification, id };

    setNotifications(prevNotifications => [...prevNotifications, newNotification]);
    setVisibleNotifications(prev => new Set(prev).add(id));

    if (newNotification.duration) {
      timers.current[id] = setTimeout(() => {
        setRemovingNotifications(prev => new Set(prev).add(id));
        setTimeout(() => removeNotification(id), 500); // Delay for slide-out animation
      }, newNotification.duration);
    }
  };

  const removeNotification = (idToRemove: string) => {
    setNotifications(prevNotifications =>
      prevNotifications.filter(notification => notification.id !== idToRemove)
    );
    setVisibleNotifications(prev => {
      const updated = new Set(prev);
      updated.delete(idToRemove);
      return updated;
    });
    setRemovingNotifications(prev => {
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

  useEffect(() => {
    // Update notification heights when notifications are rendered or updated
    const updateHeights = () => {
      const updatedHeights: Record<string, number> = {};
      Object.keys(notificationRefs.current).forEach(id => {
        const el = notificationRefs.current[id];
        if (el) {
          updatedHeights[id] = el.getBoundingClientRect().height;
        }
      });
      setNotificationHeights(updatedHeights);
    };

    updateHeights();
  }, [notifications]);

  const getOffsetStyle = useCallback((position: string, index: number): React.CSSProperties => {
    const gap = 20; 
    const baseOffset = 10; 

    let cumulativeOffset = baseOffset;
    for (let i = 0; i < index; i++) {
      const notificationId = notifications[i].id;
      const height = notificationHeights[notificationId] || 70; 
      cumulativeOffset += height + gap;
    }

    switch (position) {
      case "top-left":
        return { top: `${cumulativeOffset}px`, left: "10px", position: "absolute" };
      case "top-right":
        return { top: `${cumulativeOffset}px`, right: "10px", position: "absolute" };
      case "bottom-left":
        return { bottom: `${cumulativeOffset}px`, left: "10px", position: "absolute" };
      case "bottom-right":
        return { bottom: `${cumulativeOffset}px`, right: "10px", position: "absolute" };
      default:
        return {};
    }
  }, [notificationHeights, notifications]);

  return (
    <div className={styles.container}>
      {["top-left", "top-right", "bottom-left", "bottom-right"].map(position => {
        const notificationsForPosition = notifications.filter(n => n.position === position);
        return (
          <div key={position} className={styles[position]}>
            {notificationsForPosition.map((notification, index) => {
              const style = getOffsetStyle(position, index);

              return (
                <Box 
                  key={notification.id}
                  ref={el => { if (el) notificationRefs.current[notification.id] = el; }}
                  className={`${styles.notification}
                    ${visibleNotifications.has(notification.id) ? styles["slide-in"] : ""}
                    ${removingNotifications.has(notification.id) ? styles["slide-out"] : ""}`}
                  style={style}
                  onAnimationEnd={() => {
                    if (removingNotifications.has(notification.id)) {
                      removeNotification(notification.id);
                    }
                  }}
                >
                  {notification.icon === "progress" ? (
                    <Loader size="sm" color="violet" style={{ marginRight: 12 }} />
                  ) : notification.icon === "success" ? (
                    <div style={{ marginRight: 12 }}>
                      <CiSquareCheck size="2.0rem" color="#12b886" />
                    </div>
                  ) : notification.icon === "error" ? (
                    <div style={{ marginRight: 12 }}>
                      <MdOutlineCancelPresentation size="2.0rem" color="#f03e3e" />
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
              );
            })}
          </div>
        );
      })}
    </div>
  );
};

export default NotificationComponent;
