//
//  SupabaseManager.swift
//  hello you
//
//  Owns the shared SupabaseClient. The anon key below is meant to be
//  public — it's the client-side credential Supabase expects apps to
//  ship with; access control lives in Row Level Security policies, not
//  in keeping this secret.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()

    static let supabaseURL = URL(string: "https://dehfiaibuvconewthtoo.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlaGZpYWlidXZjb25ld3RodG9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ0MDg1MDIsImV4cCI6MjA5OTk4NDUwMn0.yt5tLbxtpMpw1rEAzsKBCot4CN3hu-hZ1o32no6EK0s"

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(supabaseURL: Self.supabaseURL, supabaseKey: Self.supabaseAnonKey)
    }

    /// Hits Supabase's own Auth health endpoint — a lightweight, public
    /// probe with no schema/table dependency, so it works against any
    /// project regardless of what's been set up in the database yet.
    /// (The PostgREST root at /rest/v1/ looked tempting for this, but on
    /// current Supabase projects that path's OpenAPI introspection is
    /// restricted to the service_role key, so it 401s for anon by design
    /// — not a sign anything here is misconfigured.)
    func runHealthCheck() async {
        var request = URLRequest(url: Self.supabaseURL.appendingPathComponent("auth/v1/health"))
        request.httpMethod = "GET"
        request.setValue(Self.supabaseAnonKey, forHTTPHeaderField: "apikey")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                print("❌ [Supabase] Health check failed: response was not HTTP")
                return
            }
            if (200..<300).contains(http.statusCode) {
                print("✅ [Supabase] Health check passed — reached \(Self.supabaseURL.host ?? "Supabase") (HTTP \(http.statusCode))")
            } else {
                print("❌ [Supabase] Health check failed — HTTP \(http.statusCode) from \(Self.supabaseURL.host ?? "Supabase")")
            }
        } catch {
            print("❌ [Supabase] Health check failed — \(error.localizedDescription)")
        }
    }
}
