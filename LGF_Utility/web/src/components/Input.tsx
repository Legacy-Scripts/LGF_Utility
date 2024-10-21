import React, { useState, useCallback, useEffect } from "react";
import {
  TextInput,
  Select,
  NumberInput,
  PasswordInput,
  Textarea,
  Button,
  Grid,
  Col,
  Text,
  useMantineTheme,
  Group,
  Box,
  Badge,
  Title,
  Transition,
  Divider,
} from "@mantine/core";
import { fetchNui } from "../utils/fetchNui";
import styled from "styled-components";

const ScrollBarData = styled.div`
  overflow-y: auto;
  overflow-x: hidden;
  flex-grow: 1;
  padding-bottom: 1rem;
  scrollbar-width: none;
  -ms-overflow-style: none;

  &::-webkit-scrollbar {
    display: none;
  }
`;

interface FieldOption {
  label: string;
  value: string;
}

interface Field {
  label: string;
  placeholder?: string;
  type?: "text" | "number" | "select" | "password" | "textarea";
  options?: FieldOption[];
  description?: string;
  min?: number;
  max?: number;
  required?: boolean;
  disabledInput?: boolean;
}

interface InputData {
  id: string;
  title: string;
  fields: Field[];
  canClose?: boolean;
  titleButton?: string;
}

const InputComponent = () => {
  const [inputData, setInputData] = useState<InputData | null>(null);
  const [formValues, setFormValues] = useState<{ [key: number]: any }>({});
  const [modalOpen, setModalOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [closing, setClosing] = useState(false);
  const theme = useMantineTheme();

  const handleMessage = useCallback((event: MessageEvent) => {
    const data = event.data;
    if (data.action === "showInputForm") {
      const { fields, canClose } = data.data;
      if (Array.isArray(fields) && typeof canClose === "boolean") {
        setInputData(data.data);
        setModalOpen(true);
      } else {
        console.error("Invalid data format:", data.data);
      }
    } else if (data.action === "closeInputForm") {
      setInputData(null);
      setModalOpen(false);
    }
  }, []);

  useEffect(() => {
    window.addEventListener("message", handleMessage);
    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, [handleMessage]);

  const handleSubmit = async () => {
    const allFieldsFilled = inputData?.fields.every((field, index) => {
      if (field.required) {
        const value = formValues[index];
        return value !== undefined && value !== null && value !== "";
      }
      return true;
    });

    if (!allFieldsFilled) {
      console.error("Please fill in all required fields.");
      return;
    }

    setSubmitting(true);
    setClosing(true);

    setTimeout(async () => {
      try {
        const formattedValues = Object.values(formValues);
        await fetchNui<void>("input:Submit", {
          inputID: inputData?.id,
          fields: formattedValues,
        });
      } catch (error) {
        console.error("Error submitting data:", error);
      } finally {
        setSubmitting(false);
      }
    }, 1500);
  };

  const handleFieldChange = (index: number, value: any) => {
    setFormValues((prevValues) => ({ ...prevValues, [index]: value }));
  };

  const handleClose = async () => {
    if (inputData?.canClose) {
      setClosing(true);
      try {
        await fetchNui("input:Close", { inputID: inputData.id });
      } catch (error) {
        console.error("Error closing the modal:", error);
      } finally {
        setModalOpen(false);
        setClosing(false);
        setInputData(null);
        setFormValues({});
      }
    } else {
      console.log("Modal cannot be closed without submitting.");
    }
  };

  useEffect(() => {
    if (closing) {
      const timer = setTimeout(() => {
        setModalOpen(false);
        setClosing(false);
        setInputData(null);
        setFormValues({});
      }, 2000);

      return () => clearTimeout(timer);
    }
  }, [closing]);

  const renderInputField = (field: Field, index: number) => {
    const inputStyles = { marginBottom: "0px" };

    const isDisabled = field.disabledInput || false;

    switch (field.type) {
      case "text":
        return (
          <TextInput
            placeholder={field.placeholder}
            onChange={(event) => handleFieldChange(index, event.target.value)}
            style={inputStyles}
            required={field.required}
            size="xs"
            disabled={isDisabled}
          />
        );
      case "number":
        return (
          <NumberInput
            placeholder={field.placeholder}
            min={field.min}
            max={field.max}
            onChange={(value) => handleFieldChange(index, value)}
            style={inputStyles}
            required={field.required}
            size="xs"
            disabled={isDisabled}
          />
        );
      case "select":
        return (
          <Select
            placeholder={field.placeholder}
            data={field.options || []}
            onChange={(value) => handleFieldChange(index, value)}
            style={inputStyles}
            required={field.required}
            size="xs"
            withinPortal={true}
            disabled={isDisabled}
          />
        );
      case "password":
        return (
          <PasswordInput
            placeholder={field.placeholder}
            onChange={(event) => handleFieldChange(index, event.target.value)}
            style={inputStyles}
            required={field.required}
            size="xs"
            disabled={isDisabled}
          />
        );
      case "textarea":
        return (
          <Textarea
            placeholder={field.placeholder}
            onChange={(event) => handleFieldChange(index, event.target.value)}
            style={inputStyles}
            required={field.required}
            size="xs"
            disabled={isDisabled}
          />
        );
      default:
        return null;
    }
  };

  return (
    <Transition
      mounted={modalOpen}
      transition="slide-right"
      duration={400}
      timingFunction="ease"
    >
      {(styles) => (
        <div
          className="custom-overlay"
          style={{
            position: "fixed",
            top: 0,
            left: "10px",
            width: "500px",
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            ...styles,
          }}
        >
          <Box
            p="sm"
            style={{
              backgroundColor:
                theme.colorScheme === "dark"
                  ? theme.colors.dark[9]
                  : theme.colors.gray[1],
              boxShadow: theme.shadows.sm,
              width: "80%",
              maxWidth: "500px",
              minHeight: "20%",
              maxHeight: "80%",
              overflow: "hidden",
              position: "relative",
              transition: "transform 0.3s ease-in-out",
              margin: "1.5vh",
              display: "flex",
              flexDirection: "column",
            }}
          >
            <Title order={4} align="center" mb="xs">
              {inputData?.title}
            </Title>
            <Divider my="sm" variant="dotted" />
            <ScrollBarData>
              <Grid gutter="xs">
                {Array.isArray(inputData?.fields) ? (
                  inputData.fields.map((field, index) => (
                    <Col span={12} key={index}>
                      <Box
                        p="xs"
                        style={{
                          backgroundColor:
                            theme.colorScheme === "dark"
                              ? theme.colors.dark[7]
                              : theme.colors.gray[1],
                          borderRadius: theme.radius.sm,
                          boxShadow: theme.shadows.xs,
                        }}
                      >
                        <div style={{ marginBottom: "0.25rem" }}>
                          <Text tt="uppercase" weight={500} size="xs">
                            {field.label}
                            {field.required && (
                              <Badge
                                size="xs"
                                radius="sm"
                                color="red"
                                variant="light"
                                ml="xs"
                              >
                                Required
                              </Badge>
                            )}
                          </Text>
                          {field.description && (
                            <Text size="xs" color="dimmed" mt="xs">
                              {field.description}
                            </Text>
                          )}
                        </div>
                        {renderInputField(field, index)}
                      </Box>
                    </Col>
                  ))
                ) : (
                  <Text tt="uppercase" >
                  </Text>
                )}
              </Grid>
            </ScrollBarData>
            <Group position="right" mt="sm">
              <Button
                variant="light"
                color="teal"
                onClick={handleSubmit}
                loading={submitting}
                size="xs"
              >
                {inputData?.titleButton}
              </Button>
              {inputData?.canClose && (
                <Button
                  variant="light"
                  color="red"
                  style={{ marginLeft: "5px" }}
                  onClick={handleClose}
                  size="xs"
                >
                  Close
                </Button>
              )}
            </Group>
          </Box>
        </div>
      )}
    </Transition>
  );
};

export default InputComponent;
