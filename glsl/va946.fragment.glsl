// by @eddbiddulph
//
// This is a motion-blur experiment. Move the mouse into the grey zone on the left to reset
// the rendering. 16 jittered samples are taken. This works by using the alpha channel of the
// 'backbuffer' texture to record the number of samples taken so far. I'm not sure if the alpha
// channel is always usable like this on glslsandbox, so be aware of that if you don't see a
// blue ball striking a yellow cup.

#ifdef GL_ES
precision highp float;
#endif

#define MOUSE_RESET_ZONE_X 0.1
#define EPS vec3(0.0001, 0.0, 0.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float circle(vec2 o, float r, vec2 p)
{
	return distance(p, o) - r;
}

float box(vec2 o, vec2 s, vec2 p)
{
	return length(max(vec2(0.0), abs(p - o) - s));
}

float wineGlassProfile(vec2 p)
{
	p.y = -p.y - 0.7;

	vec2 a = vec2(0.45, 0.67), b = vec2(0.0, 0.2);
	float g = 0.4, h = (a.x - b.x) - g;
	vec2 c = vec2(h, -0.9), d = vec2(0.2, -1.15), c2 = vec2(0.0, c.y);
	float i = (d.x - c2.x) - h, j = 0.72, k = (c2.y - d.y) - i;
	float l = 0.6, m = 0.8, f = a.y - b.y - g;

	float dist;
	
	// base
	dist = box(vec2(b.x, a.y - f * 0.5), vec2(m, f * 0.5 - 0.05), p) - 0.05;

	// bottom of stem
	dist = min(dist, max(box((a + b) * 0.5, abs(a - b) * 0.5, p), -circle( vec2(a.x, b.y), g, p)));

	// stem
	dist = min(dist, box((c + b) * 0.5, abs(b - c) * 0.5, p));

	// top of stem
	dist = min(dist, max(box((c2 + d) * 0.5, abs(d - c2) * 0.5, p), -circle( vec2(d.x, c2.y), i, p))   );

	// base of body
	dist = min(dist, max(max(max(circle(vec2(d.x, (d.y - j) + k), j, p), -circle(vec2(d.x, (d.y - j) + k), j - k, p)), d.x - p.x), d.y - j + k - p.y));

	// body
	dist = min(dist, -0.05 + box(vec2(d.x + j - k * 0.5, (d.y - j) + k - l * 0.5 ), vec2(k * 0.5 - 0.05, l * 0.5), p));

	return dist;
}

// signed distance function for wine-glass model. revolution of profile
// is around z-axis. the base of the glass is at a higher z than the rim.
float wineGlass(vec3 p)
{
	return wineGlassProfile(vec2(length(p.xy), p.z));
}

vec3 rotateZ(vec3 v, float a)
{
	return vec3(cos(a) * v.x - sin(a) * v.y, sin(a) * v.x + cos(a) * v.y, v.z);
}

vec3 rotateX(vec3 v, float a)
{
	return vec3(v.x, cos(a) * v.y - sin(a) * v.z, sin(a) * v.y + cos(a) * v.z);
}

vec3 wineGlassNorm(vec3 p)
{
    float dist = wineGlass(p);
    return normalize(vec3(wineGlass(p + EPS.xyz) - dist, wineGlass(p + EPS.zxy) - dist, wineGlass(p + EPS.yzx) - dist));
}

vec3 light(vec3 diff, vec3 spec, vec3 pos, vec3 lpos, vec3 eye, vec3 norm, float spec_exp)
{
    vec3 ldir = normalize(lpos - pos), refl = reflect(normalize(pos - eye), norm);

    return  diff * max(0.0, 0.5 + dot(ldir, norm) * 0.5) +
            spec * pow(max(0.0, dot(refl, ldir)), spec_exp);
}

vec3 wineGlassColour(vec3 p, vec3 n, vec3 eye)
{
    return light(vec3(1.0, 0.6, 0.2), vec3(1.0), p, vec3(5.0, 5.0, -1.0), eye, n, 30.0);
}

float sphere(vec3 o, float r, vec3 p)
{
    return distance(p, o) - r;
}

// trace a ray into the scene with the given time 0.0 <= t <= 1.0
// returns the final pixel colour
vec3 trace(float t, vec3 ro, vec3 rd)
{
	float angle_x = 1.6, angle_z = max(0.0, t - 0.2) * 1.3;

	vec3 eye = ro;

    int hit_id = 0;
    
    // ricocheting blue ball motion
    vec3 spos = (t < 0.2) ? mix(vec3(-3.0, 1.0, -0.5), vec3(-1.0, 1.0, -0.5), t / 0.2) : 
                            mix(vec3(-1.0, 1.0, -0.5), vec3(-1.5, 2.0, -0.5), (t - 0.2) / 0.8);
                            
    float srad = 0.2;
    
	for(int i = 0; i < 60; ++i)
	{
		float dist0 = wineGlass(rotateX(rotateZ(ro, angle_z), angle_x)),
              dist1 = sphere(spos, srad, ro);

		if(dist0 < 0.01)
		{
            hit_id = 1;
			break;
		}
		else if(dist1 < 0.01)
		{
            hit_id = 2;
			break;
		}
        
		ro += rd * min(dist0, dist1);

		if(distance(ro, eye) > 8.0)
			break;
	}
    
    if(hit_id == 1) 
    {
        // get normal in object space from intersection point in object space, then transform
        // normal to view space.
        vec3 n = rotateZ(rotateX(wineGlassNorm(rotateX(rotateZ(ro, angle_z), angle_x)), -angle_x), -angle_z);
        
        return wineGlassColour(ro, n, eye);
    }
    if(hit_id == 2)
    {
        // blue ball shading
        return light(vec3(0.6, 0.6, 1.0), vec3(1.0), ro, vec3(5.0, 5.0, -1.0), eye, normalize(ro - spos), 10.0);
    }
    else
        return vec3(0.0);
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

    vec2 coord = gl_FragCoord.xy / resolution.xy;
    vec4 backcol = texture2D(backbuffer, coord);

	vec3 rd = vec3(0.0, 0.0, 1.0);
	vec3 ro = vec3(0.0, 0.0, -5.0);

	rd.xy = vec2(coord - 0.5) * vec2(resolution.x / resolution.y, 1.0);

    rd = normalize(rd);
    
    // increment the sample count
    gl_FragColor.a = min(1.0, backcol.a + 1.0 / 255.0);

    const float max_samples = 16.0;
    float sample_num = gl_FragColor.a * 255.0;
    
    float t = (mod(rand(gl_FragCoord.xy), 1.0) + sample_num - 1.0) / (max_samples - 1.0);

    float brighten = 1.3;
    
    if(coord.x < MOUSE_RESET_ZONE_X)
    {
        gl_FragColor.a = 0.0;
        gl_FragColor.rgb = vec3(0.2);
    }
    else
    {
        gl_FragColor.rgb = (sample_num <= max_samples) ? (backcol.rgb + (trace(t, ro, rd) * brighten) / max_samples) : backcol.rgb;

        if(mouse.x < MOUSE_RESET_ZONE_X)
        {
            gl_FragColor.rgba = vec4(0.0); // reset
        }
    }
}