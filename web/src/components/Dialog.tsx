import React, { useState, useCallback, useEffect } from "react";
import {
  Button,
  Text,
  Card,
  Center,
  useMantineTheme,
  Loader,
  Image,
} from "@mantine/core";
import { fetchNui } from "../utils/fetchNui";
import { MdNavigateNext } from "react-icons/md";
import { IoIosArrowBack, IoIosClose } from "react-icons/io";


interface CardData {
  title: string;
  message: string;
  actionLabel?: string;
  actionCloseLabel?: string;
  hasOnAction?: boolean;
  hasOnClose?: boolean;
  image?: string;
}

interface DialogData {
  id: string;
  title: string;
  cards: CardData[];
}

const CenteredContainer: React.FC = () => {
  const theme = useMantineTheme();
  const [dialog, setDialog] = useState<DialogData | null>(null);
  const [isVisible, setIsVisible] = useState(false);
  const [currentCardIndex, setCurrentCardIndex] = useState(0);

  const hideDialog = useCallback(() => {
    setIsVisible(false);
    setDialog(null);
    setCurrentCardIndex(0);
  }, []);

  const showDialog = useCallback((data: DialogData) => {
    setDialog(data);
    setCurrentCardIndex(0);
    setIsVisible(true);
  }, []);

  const handleAction = async () => {
    try {
      const cardIndex = currentCardIndex + 1;
      const card = dialog?.cards[currentCardIndex];
      if (!card) {
        return;
      }
      if (card.hasOnAction) {
        await fetchNui("dialogAction", { id: dialog!.id, cardIndex });
      }
      if (currentCardIndex < dialog!.cards.length - 1) {
        setCurrentCardIndex((prevIndex) => prevIndex + 1);
      } else {
        await fetchNui("dialogClose", {
          id: dialog!.id,
          cardIndex: currentCardIndex + 1,
        });
      }
    } catch (error) {
      console.error("Error handling action:", error);
    }
  };

  const handleClose = async () => {
    try {
      const cardIndex = currentCardIndex + 1;
      const card = dialog?.cards[currentCardIndex];
      await fetchNui("dialogClose", {
        id: dialog!.id,
        cardIndex: cardIndex,
      });
      hideDialog();
    } catch (error) {
      console.error("Error sending close to NUI:", error);
    }
  };

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data.action === "showDialog") {
        showDialog(data);
      } else if (data.action === "hideDialog") {
        hideDialog();
      }
    };





    window.addEventListener("message", handleMessage);
    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, [showDialog, hideDialog]);

  

  if (!isVisible || !dialog) {
    return null;
  }

  const currentCard = dialog.cards[currentCardIndex];

  if (!currentCard) {
    return null;
  }

  return (
    <div className="centered-container">
      <Card
        shadow="lg"
        padding="lg"
        radius="md"
        // withBorder
        style={{
          maxWidth: "500px",
          width: "100%",
          position: "relative",
          animation: "slideIn 0.5s ease-out",
          backgroundColor:
            theme.colorScheme === "dark"
              ? theme.colors.dark[9]
              : theme.colors.gray[1],
        }}
      >
        <div
          style={{
            position: "absolute",
            top: "15px",
            left: "15px",
            zIndex: 2000,
          }}
        >
          <Loader size="lg" color="rgba(54, 156, 129, 0.381)" />
        </div>
        <Text size="xl" weight={700} align="center" mb="lg">
          {dialog.title}
        </Text>
        <div style={{ textAlign: "center" }}>
          {currentCard.image && (
            <Image
              src={currentCard.image}
              alt={currentCard.title}
              fit="cover"
              radius="md"
              style={{ marginBottom: "16px", maxHeight: "200px" }}
            />
          )}
          <Text size="lg" weight={500} mb="md">
            {currentCard.title}
          </Text>
          <Text size="md" mb="md">
            {currentCard.message}
          </Text>
        </div>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            marginTop: "auto",
          }}
        >
          <Button
            variant="light"
            color="red"
            leftIcon={<IoIosArrowBack size={19} />}
            onClick={() =>
              setCurrentCardIndex((prevIndex) => Math.max(prevIndex - 1, 0))
            }
            disabled={currentCardIndex === 0}
          >
            Back
          </Button>
          {currentCard.hasOnAction && (
            <Button variant="light" color="green" onClick={handleAction}>
              {currentCard.actionLabel || "Action"}
            </Button>
          )}
          {currentCardIndex === dialog.cards.length - 1 ? (
            <Button
              rightIcon={<IoIosClose size={24} />}
              variant="light"
              color="red"
              onClick={handleClose}
            >
              {currentCard.actionCloseLabel || "Close"}
            </Button>
          ) : (
            <Button
              variant="light"
              color="blue"
              rightIcon={<MdNavigateNext size={24} />}
              onClick={() => setCurrentCardIndex((prevIndex) => prevIndex + 1)}
            >
              Next
            </Button>
          )}
        </div>
      </Card>
    </div>
  );
};

export default CenteredContainer;
