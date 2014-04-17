#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

  float sphere( vec3 p ) { return length(p) - 0.10; }
  float box( vec3 p ) {
      return max(
       max(
	  p.x * p.x - 0.1,
	  p.y * p.y - 0.1
	  ),
	  p.z * p.z - 0.1
	  );
      }

  vec3 translate(vec3 p, vec3 v) { return p - v; } 

  float or( float a, float b ) { return min(a,b); }
  float and( float a, float b ) { return max(a,b); }

float wobbly(vec3 p, float t)
{
    const float ripple = 0.5;
    return distance(p, vec3(
	  0.0+sin(p.y* 6.0 * sin(t*2.) + t * 0.1)*ripple * sin(t*0.05) * 0.8,
	  0.0+sin(p.x* 7.0 * sin(t*2.7) + t * 0.1)*ripple * sin(t*0.03) * 0.8,
	  0.0+sin(p.x* 9.0 * sin(t*2.3) + t * 0.1)*ripple * sin(t*0.04) * 0.8)) - 0.1;
}

  float sdf( vec3 p) {
      float ripple = 0.8;
      //return min( box(p), sphere(p));
      //return box(translate(p, vec3(0., 0., 2.)));
      //return and( box(p), sphere(p * 1.5) );
      /*
      return or(
	  sphere(translate(p, vec3(-0.5, 0., 2.))),
	  sphere(translate(p, vec3(+0.5, 0., 2.)))
      );
      */
      float t = time * 0.1;
      return min(wobbly(p, time * 1.1),wobbly(p, time * 1.5));
  }

void main(void) {
    vec3 pos = vec3((gl_FragCoord.x / resolution.x) - 0.5, (gl_FragCoord.y / resolution.x) - 0.3, 0.0);
    vec3 direction = pos - vec3(0.0, 0.0, -1.0);

    // ray marching
    float d = 10.0;
    const int iterations = 32; // should be as low as possible
    for(int i=0; i<iterations; ++i) {
        d = sdf(pos);
	pos += direction * d;
	if(d < 0.01 || pos.z > 100.0) break;
    }

    float r = 0.0, g = 0.0, b = 0.0;
    if(d<=0.01) {

        // estimate normal based on finite difference approx of gradient
	vec3 gradient = sdf(pos) - vec3(
	      sdf(pos + vec3(.001,.000,.000)),
	      sdf(pos + vec3(.000,.001,.000)),
	      sdf(pos + vec3(.000,.000,.001))
	      );
      	vec3 normal = normalize( gradient );

	// diffuse light = lightpos dot normal
        // red diffuse light
	vec3 l = normalize(vec3(0.5,-0.5,+0.5));
	r = dot( normal, l ) * 1.4;
	// green diffuse light
	g = dot( normal, normalize(vec3(-0.4,0.4,+0.4))) * 0.5;
	// blue diffuse light
	b = dot( normal, normalize(vec3(0.9,-0.3,+0.4))) * 0.6;
    }
    gl_FragColor = vec4(r, g, b, 1.0);
}