#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// distance ( s = size, minus return = inside )
float triangle(vec2 p, float s)
{
	return max(abs(p.x) * 0.866025 + p.y * 0.5, -p.y) - s * 0.5;
}

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float line(vec2 p, vec2 v, vec2 w) {
	float l2 = distance(w, v);
	l2 *= l2;
	float t = dot(p - v, w - v) / l2;
	if (t < 0.0) return distance(p, v);
	else if (t > 1.0) return distance(p, w);
	vec2 projection = v + t * (w - v); 
	return distance(p, projection);
}

// triangle wave ( l = wave length )
float tw( float x, float l ){ return (abs(fract(x/l-0.25)-0.5)-0.25)*l; }

float distfunc(vec2 p)
{
	float r = cos(time*0.125443)*0.2+1.0;
	float S = sin(time/3.14)*r;
	float C = cos(time/3.14)*r;
	float zoom = 1.1/r;
	float w = 3.0;
	float d = 0.0;
	for ( int i = 0; i < 15; i++ ){
		p = vec2(p.x * C - p.y * S + mouse.x*w + 0.2, p.y * C + p.x * S + mouse.y*w)*zoom;
		p = vec2( tw(p.x, w), tw(p.y, w) );
		d = min(d, triangle(p, 0.2));
		w = w * 0.9;
	}
	return d;
}

void main()
{

	vec2 position = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
	position.x *= resolution.x / resolution.y;

	float dist = distfunc(position);
	gl_FragColor = vec4(sin(dist*32.0*3.0)*0.5+0.5);

}