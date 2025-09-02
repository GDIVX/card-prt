shader_type canvas_item;

// ---------- Wave (shape) ----------
uniform float frequency   = 1.5;
uniform float amplitude   = 0.1;      // expressed in UV-space now (0..1)
uniform float wave_speed  = 1.0;
uniform float direction   : hint_range(-1.0, 1.0) = 1.0;

// ---------- Line body ----------
uniform float thickness   = 0.6;
uniform float edge_soft   = 0.02;

// ---------- Dash / ants ----------
uniform float dash_repeat   = 24.0;
uniform float dash_duty     : hint_range(0.02, 0.98) = 0.4;
uniform float dash_speed    = 1.5;
uniform float dash_soft     = 0.02;
uniform float dash_angle_deg = 0.0;

// ---------- Color ----------
uniform vec4 color1 : source_color = vec4(1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

// ---------- Helpers ----------
float aa_smooth_edge(float d, float softness) {
    float w = max(softness, fwidth(d));
    return smoothstep(-w, w, d);
}

vec2 rotate(vec2 p, float ang) {
    float c = cos(ang), s = sin(ang);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void fragment() {
    vec2 uv = UV;

    float phase = uv.x * frequency + TIME * wave_speed * direction;
    uv.y += sin(phase) * amplitude;

    float half_thickness = clamp(thickness * 0.5, 0.0, 0.5);
    float dist_to_center = 0.5 - abs(uv.y - 0.5);
    float line_mask = aa_smooth_edge(dist_to_center - half_thickness, edge_soft);

    float ang = radians(dash_angle_deg);
    vec2 uv_dash = rotate(vec2(uv.x, uv.y), ang);

    float scroll = TIME * dash_speed * direction;
    float stripe = fract(uv_dash.x * dash_repeat - scroll);

    float dash_sd = (dash_duty - stripe);
    float dash_mask = aa_smooth_edge(dash_sd, dash_soft);

    vec4 dashed = mix(color2, color1, dash_mask);

    float center_falloff = smoothstep(0.0, 1.0, dist_to_center / half_thickness);
    vec4 final_col = mix(dashed * 0.95, dashed, center_falloff);

    final_col.a *= line_mask * opacity;
    COLOR = final_col;
}
