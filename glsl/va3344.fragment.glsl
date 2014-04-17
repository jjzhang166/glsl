//mod by ME smooth shape 

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

float smoothstepVar(float edge1, float edge2, float curve, float value)
{
	float width = edge2 - edge1;
	float phase = (value - edge1) / width;
	phase = clamp(phase,0.0,1.0);
	curve = (curve + 0.025) * 99.075;
	float outValue = pow(phase,curve);
	return outValue;
}

float box(float e0, float e1, float x)
{
    return step(e0, x) - step(e1, x);
}

float section(  float y0, float y1, float dxdy0, float dxdy1,
                float x0_ofs, float x1_ofs, vec2 p)
{
    float x0 = dxdy0 * p.y + x0_ofs, x1 = dxdy1 * p.y + x1_ofs;
    return box(y0, y1, p.y) * box(x0, x1, p.x);
}

float segmentShape(vec2 p, vec2 s0, vec2 s1, float radius)
{
	vec2 d = normalize(s1 - s0);
	float slen = distance(s0, s1);

	float	d0 = max(abs(dot(p - s0, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(p - s0, d) - slen * 0.5) - slen * 0.5, 0.0);

	return 1.-smoothstep(length(vec2(d0, d1)), length(vec2(d0*0.5, d1*0.5)), radius);
}

float circle(vec2 p, float radius, float softness) {
	float r = length( p );
	float a = atan( p.y, p.x );
	r *= 1.0 + clamp(1.0-r,0.0,1.0);
	return 1.0-smoothstep( radius, radius + softness, r );
}

vec3 shape(vec2 p, vec2 offset, float size) {
	
	p += offset;
	
	vec3 color = vec3(0.0);
	float radius = 0.02; 
	float col, len = 0.0;
	vec2 sp0, sp1 = vec2(0);
	
	sp0 = vec2(0.25) * size;
	sp1 = vec2(-0.25) * size;
	len = segmentShape(p, sp0, sp1, radius * size);
	len = clamp(len, 0.0, 1.0);
	col = mix(col, 1.0, len);
	
	sp0 = vec2(0.25, -0.25) * size;
	sp1 = vec2(-0.25,  0.25) * size;
	len = segmentShape(p, sp0, sp1, radius * size);
	len = clamp(len, 0.0, 1.0);
	col = mix(col, 1.0, len);
	
	sp0 = vec2( 0.3,  0.25) * size;
	sp1 = vec2(-0.3,  0.25) * size;
	len = segmentShape(p, sp0, sp1, radius*2. * size);
	len = clamp(len, 0.0, 1.0);
	col = mix(col, 1.0, len);
	
	sp0 = vec2( 0.3, -0.25) * size;
	sp1 = vec2(-0.3, -0.25) * size;
	len = segmentShape(p, sp0, sp1, radius*2. * size);
	len = clamp(len, 0.0, 1.0);
	col = mix(col, 1.0, len);
	
	len = circle ( vec2( 0.0, 0.125) + p, 0.00, 0.05);
	len = clamp(len, 0.0, 1.0);
	col = mix(col, 0.0, len);
	
	color += vec3(col, col, col);
	return color;
}

void main( void ) {
	
	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5)) * vec2(resolution.x / resolution.y, 1.0);
	float rads = radians(time*10.0);
	//p = rotate(p, rads);
	
	vec3 color = vec3(0);
	color += shape(p, vec2(0.0,0.0), 0.5);
	gl_FragColor = vec4(color, 1.0) ;
				
}