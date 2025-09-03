shader_type canvas_item;
// Optional if you want extra punch on dark backgrounds:
// render_mode blend_mix; // or try: render_mode blend_add;

uniform float radius = 128.0;

uniform vec4  fill_color      : source_color = vec4(0.8, 0.2, 0.2, 0.25);
uniform vec4  ring_color      : source_color = vec4(1.0, 0.6, 0.3, 1.0);
uniform float ring_width = 3.0;
uniform float ring_feather = 2.0;
uniform float edge_feather = 8.0;

uniform float sweep_speed = 0.6;
uniform float sweep_freq  = 8.0;
uniform float sweep_intensity = 0.35;

/* Distortion (yours) */
uniform float noise_scale = 0.05;
uniform float noise_amp   = 6.0;
uniform float noise_speed = 0.5;

/* Ray distortion (yours) */
uniform float ray_noise_scale = 1.6;
uniform float ray_noise_speed = 0.35;
uniform float ray_distort_amp = 0.9;
uniform float ray_thick_var   = 0.45;
uniform float ray_edge_bias   = 0.35;

/* NEW: Glow controls */
uniform vec3  glow_tint    = vec3(1.0, 0.7, 0.35); // color of bloom
uniform float glow_power   = 1.6;  // overall emission strength
uniform float glow_rim_boost = 1.4; // extra emission on the rim
uniform float glow_ray_boost = 1.0; // emission from the inner rays

varying vec2 local_pos;

float soft_step(float a, float b, float x) {
    return smoothstep(a, b, clamp(x, min(a,b), max(a,b)));
}

/* value noise + fbm (from previous message) */
float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123); }
float noise2(vec2 p){
    vec2 i = floor(p), f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a,b,u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}
float fbm(vec2 p){
    float a = 0.5, s = 0.0;
    for (int i=0;i<4;i++){ s += a*noise2(p); p = p*2.03 + 17.0; a *= 0.5; }
    return s;
}

void vertex(){ local_pos = VERTEX; }

void fragment() {
    // --- edge distortion ---
    vec2 npos = local_pos / radius;
    float n = noise2(npos * (1.0 / max(1e-6, noise_scale)) + TIME * noise_speed);
    vec2 p = local_pos + normalize(local_pos) * (n * noise_amp);

    float d   = length(p);
    float ang = atan(p.y, p.x);
    float t   = TIME;

    // --- ray distortion ---
    vec2 rp = p / radius;
    float rf1 = fbm(rp * ray_noise_scale + vec2(0.0, t * ray_noise_speed));
    float rf2 = fbm((rp * 1.913 + 11.7) * (ray_noise_scale * 0.67) + vec2(t * ray_noise_speed));

    float ang_warp   = ang + (rf1 - 0.5) * (ray_distort_amp * 2.0);
    float thick_warp = mix(1.0, 1.0 + ray_thick_var, rf2);
    float edge_bias  = pow(clamp(d / max(1e-6, radius), 0.0, 1.0), ray_edge_bias);

    // --- inner rays ---
    float phase = sweep_freq * ang_warp - (t * sweep_speed * 6.2831853);
    float wave  = 0.5 + 0.5 * sin(phase);
    float rim_fade_px = 6.0 * thick_warp;
    float sweep_mask  = soft_step(radius, radius - rim_fade_px, d) * edge_bias;

    // Base color
    vec4 col = fill_color;
    col.rgb += ring_color.rgb * sweep_intensity * wave * sweep_mask;

    // --- soft disc edge ---
    float disc_alpha = soft_step(radius + edge_feather, radius - edge_feather, d);
    col.a *= disc_alpha;

    // --- outline ---
    float inner = soft_step(radius - ring_width + ring_feather, radius - ring_width - ring_feather, d);
    float outer = soft_step(radius + ring_feather, radius - ring_feather, d);
    float ring_a = clamp(outer - inner, 0.0, 1.0);
    col = mix(col, vec4(ring_color.rgb, 1.0), ring_a);

    // ========= HDR EMISSION for glow =========
    // Build a glow mask from rim + rays. This can exceed 1.0 to trigger bloom.
    float glow_mask = 0.0;
    glow_mask += ring_a * glow_rim_boost;
    glow_mask += wave * sweep_mask * glow_ray_boost;

    // Push HDR brights; don’t clamp to 1.0 — let it go > 1.0.
    col.rgb += glow_tint * glow_power * glow_mask;

    COLOR = col;
}
