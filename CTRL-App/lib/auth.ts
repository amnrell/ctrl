import { apiFetch } from "@/src/config/api";
import { API_BASE_URL } from "../config/api";


export type LoginResponse = {
    access_token: string;
    token_type: string;
};

export async function login(email: string, password: string) {
    return apiFetch<LoginResponse>("/api/v1/auth/login", {
        method: "POST",
        body: { email, password },
    });
}
