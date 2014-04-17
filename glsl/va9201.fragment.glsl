//
// SDF experiments in 2D
// animated Softmax / Softmin sdf circles
//
// First we learn to count, then we put buildings and other discontinuity into nature
// and then we invented the raster pipeline... and now we're screwed ?
//
// Can somebody put a rectangle in here? :)
//
// Florian Hoenig
// @rianflo
//
//

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 softmax(vec3 a, vec3 b, float k)
{
	return log(exp(k*a)+exp(k*b))/k;
}

vec3 softmin(vec3 a, vec3 b, float k)
{
	return -(log(exp(k*-a)+exp(k*-b))/k);
}

vec3 sdfCircle(vec2 p, vec2 t, float r) 
{
	vec2 tp = p-t;
        float l = length(tp);
        vec2 grad = tp/l;
        return vec3(grad, l-r);
}	


void main( void ) 
{
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = mouse * 2.0 - 1.0;
	m.x *= resolution.x / resolution.y;
	vec3 sdf = sdfCircle(p, vec2(0), 0.3);
	float tau = mod(time, 5.0)*10.0;
	sdf = softmin(sdf, sdfCircle(p, m, 0.08), tau); 
	sdf = softmax(sdf, -sdfCircle(p, vec2(-0.2), 0.1), tau);
	gl_FragColor = (sdf.z<0.0) ? vec4(0.0) : vec4( sdf.xy*0.5+0.5, 1.0, 1.0 );
}