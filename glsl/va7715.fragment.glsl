#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float R = resolution.y;		// Screen 'DPI'

const float PI = 3.1415926;

// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// Switched to screen space distance by Trisomie21

// fernlightning - lets vary the style: add some arrows to the hands, seconds judder a bit...

float arrowDistanceToSegment( vec2 a, vec2 b, vec2 p)
{
	float t = 0.01;
	vec2 pa = p - a;
	vec2 ba = b - a;
	
	float h = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	if(h > 0.7) t = (0.2-abs(0.8-h))*0.1; // arrow at end
	float d = length( pa - ba*h );
	
	// Screen space distance
	return clamp((t-.5*d)*R, 0., 1.);
}

float blobDistanceToSegment( vec2 a, vec2 b, vec2 p)
{
	float t = 0.005;
	vec2 pa = p - a;
	vec2 ba = b - a;
	
	float h = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	if(h > 0.9) t = h*0.01; // blob at end
	float d = length( pa - ba*h );
	
	// Screen space distance
	return clamp((t-.5*d)*R, 0., 1.);
}

void main(void)
{
	// get time
	float secs = mod( floor(time),        60.0 );
	float mins = mod( floor(time/60.0),   60.0 )+5.;
	float hors = mod( floor(time/3600.0), 24.0 );
	
	vec2 uv = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
	uv.x *= resolution.x/resolution.y;
	
	float r = length( uv );
	float a = atan( uv.y, uv.x )+PI;
    
	// background color
	vec3 col = vec3(1.0);
	
	// hours & minute marks	
	float u, h, m;
	u = r * PI*2.0 / 12.;
	h = fract(a*r/u +.5)-.5;
	h = .006-.5*abs(h*u);
	h *= (1.-step(r, .90))*step(r, .95);
	
	u = r * PI*2.0 / 60.;
	m = fract(a*r/u +.5)-.5;
	m = .0025-.5*abs(m*u);
	m *= (1.-step(r, .90))*step(r, .95);
	col = mix( col, vec3(0.0), max(m*R, 0.)+max(h*R, 0.) );
	
	// seconds hand
	float secs2 = secs - cos(time*100.0)*pow(1.0-fract(time), 3.0)*0.2; // judder on seconds
	vec2 dir;
	dir = vec2( sin(PI*2.0*secs2/60.0), cos(PI*2.0*secs2/60.0) );
	float f = blobDistanceToSegment(dir*0.88, -dir*0.25, uv);
	col = mix( col, vec3(1,0.0,0.0), f );

	// minutes hand
	float mins2 = mins + secs/60.0; // analogue minutes
	dir = vec2( sin(PI*2.0*mins2/60.0), cos(PI*2.0*mins2/60.0) );
	f = arrowDistanceToSegment( vec2(0.0), dir*0.88, uv);
	col = mix( col, vec3(0.0), f );
	
	// hours hand
	dir = vec2( sin(PI*2.0*hors/12.0), cos(PI*2.0*hors/12.0) );
	f = arrowDistanceToSegment( vec2(0.0), dir*0.6, uv);
	col = mix( col, vec3(0.0), f );

	// center mini circle	
	col = mix( col, vec3(0.0), clamp((.055-r)*R, 0., 1.) );

	// borders of watch
	col = mix( col, vec3(0.0), clamp((.005-.5*abs(r-.95))*R, 0., 1.) );
	col = mix( col, vec3(0.0), clamp((.005-.5*abs(r-.90))*R, 0., 1.) );

	gl_FragColor = vec4( col,1.0 );
}
