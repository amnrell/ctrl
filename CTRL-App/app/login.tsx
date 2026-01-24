import { useState } from "react";
import { View, TextInput, StyleSheet, Alert, Pressable } from "react-native";
import { useRouter } from "expo-router";

import { login } from "@/lib/auth";
import { API_BASE_URL } from "@/config/api";
import { ThemedText } from "@/components/themed-text";

export default function LoginScreen() {
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleLogin() {
    if (!email || !password) {
      Alert.alert("Missing fields", "Email and password are required.");
      return;
    }

    try {
      setLoading(true);

      const res = await login(email, password);

      console.log("LOGIN SUCCESS:", res);

      // TODO: store token via context / secure store
      Alert.alert("Success", "Logged in successfully");

      router.replace("/"); // go to home
    } catch (err: any) {
      Alert.alert("Login failed", err?.message ?? "Unknown error");
    } finally {
      setLoading(false);
    }
  }

  return (
    <View style={styles.container}>
      <ThemedText type="title">Login</ThemedText>

      <TextInput
        placeholder="Email"
        placeholderTextColor="#666"
        value={email}
        onChangeText={setEmail}
        autoCapitalize="none"
        keyboardType="email-address"
        style={styles.input}
      />

      <TextInput
        placeholder="Password"
        placeholderTextColor="#666"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        style={styles.input}
      />

      <Pressable
        onPress={handleLogin}
        disabled={loading}
        style={[styles.button, loading && styles.buttonDisabled]}
      >
        <ThemedText>
          {loading ? "Logging in..." : "Login"}
        </ThemedText>
      </Pressable>

      <Pressable onPress={() => router.replace("/")}>
        <ThemedText>Back to Home</ThemedText>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    padding: 24,
    gap: 16,
  },
  input: {
    backgroundColor: "#111",
    padding: 14,
    borderRadius: 8,
    color: "#fff",
  },
  button: {
    backgroundColor: "#00ff9c",
    padding: 16,
    borderRadius: 10,
    alignItems: "center",
  },
  buttonDisabled: {
    opacity: 0.6,
  },
});
