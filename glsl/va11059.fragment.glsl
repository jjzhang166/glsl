#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// progressive image-based Lindemayer-system fractal rendering
// from http://webglplayground.net/?gallery=lsystem-tree-fractal

float x1, x2, y1, y2, w1, w2, d1, d2, scale1, scale2, sin1, cos1, sin2, cos2, sin3, cos3, thickness;

/// basically just a lookup from a texture with GL_LINEAR (instead of the active GL_NEAREST method for the backbuffer) resembled in shader code - surely not very efficient, but hey it looks much better and works on Float32 textures too!
vec4 bilinear(sampler2D sampler, vec2 uv){
	vec2 pixelsize = 1./resolution;
	vec2 pixel = uv * resolution + 0.5;
	vec2 d = pixel - floor(pixel) + 0.5;
	pixel = (pixel - d)*pixelsize;
	
	vec2 h = vec2( pixel.x, pixel.x + pixelsize.x);
	if(d.x < 0.5)
		h = vec2( pixel.x, pixel.x - pixelsize.x);
	
	vec2 v = vec2( pixel.y, pixel.y + pixelsize.y);
	if(d.y < 0.5)
		v = vec2( pixel.y, pixel.y - pixelsize.y);
	
	vec4 lowerleft = texture2D(sampler, vec2(h.x, v.x));
	vec4 upperleft = texture2D(sampler, vec2(h.x, v.y));
	vec4 lowerright = texture2D(sampler, vec2(h.y, v.x));
	vec4 upperright = texture2D(sampler, vec2(h.y, v.y));
	
	d = abs(d - 0.8);
	
	return mix( mix( lowerleft, lowerright, d.x), mix( upperleft, upperright, d.x),	d.y);
}

float line_segment(vec2 domain, vec2 p1, float d1, vec2 p2, float d2){
  float h = 1./(p2.x-p1.x); // helper registers
  float h1 = (p2.y-p1.y)*h;
  float h2 = 1./h1;
  float xs = (-p1.y+h1*p1.x+h2*domain.x+domain.y)/(h2+h1);// coordinates of the point on the line between p1 and p2,
  float ys = -h2*(xs-domain.x)+domain.y;					// ^ orthogonally to the given point in the domain
  float d = length(domain-vec2(xs,ys));		// the orthogonal distance from the domain point to the line (unlimited) 
  float s = 0.; // distance from domain point to p1 relative to p2
  if(p2.x == p1.x){	// division by zero fix
    d = abs(domain.x - p1.x);
    s = (p1.y-ys)/(p1.y-p2.y);
  }else{
    s = (xs-p1.x)*h;						 
  }
  d = clamp(d*(d1*(1.-s)+d2*s),0., 1.);	// adjusting the line thickness using a linear interpolation with s
  float m1 = 0.; if(s > 0.) m1 = 1.; 		// masking out the segment between p1 and p2
  float m2 = 0.; if(s < 1.) m2 = 1.;
  float result = clamp( m1*m2-d, 0., 1.); // return result as 1-distance in the range [0..1]
  result = clamp(1.-length(domain-vec2(p1.x,p1.y))*d1-m1, result, 1.);	// round corners if you will (half circles)
  //result = clamp(1.-length(domain-vec2(p2.x,p2.y))*d2-m2, result, 1.);
 	 
  return result;
}

vec2 complex_mul(vec2 factorA, vec2 factorB){
  return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

float square_mask(vec2 domain){
  return (domain.x <= 1. && domain.x >= 0. && domain.y <= 1. && domain.y >= 0.) ? 1. : 0.; 
}

void main( void ) { 
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	x1 = 0.5;
	y1 = 0.035;
	
	x2 = 0.5 + (mouse.x - 0.5) * 0.25;
	y2 = 0.07 + mouse.y * 0.14;
	
	w1 = (0.5 - mouse.x) * 0.15;
	w2 = 0.9;
	
	scale1 = 1.23;
	scale2 = 2.5;

	d1 = (2. - mouse.y * 1.) / 0.025;
	d2 = d1 * scale1;

	sin1 = sin(w1);
	cos1 = cos(w1);
	
	sin2 = sin(w1 - w2);
	cos2 = cos(w1 - w2);
	
	sin3 = sin(w1 + w2);
	cos3 = cos(w1 + w2);
	
	vec3 color_increment =vec3(0.004,0.008,0.);

  vec2 pos1 = vec2(x1,y1);
  vec2 pos2 = vec2(x2,y2);
  vec2 c = vec2(0.5);

  gl_FragColor.xyz = vec3(1.-line_segment(uv, pos1, d1, pos2, d2));

  // complex multiplication to rotate
  vec2 uv_stem_feedback = complex_mul((uv-pos2),vec2(cos1,sin1)*vec2(scale1)) + pos1;
  vec3 stem_feedback = bilinear( backbuffer, uv_stem_feedback).xyz + color_increment;
  vec3 stem_feedback_mask = vec3(square_mask(uv_stem_feedback));
  stem_feedback *= stem_feedback_mask;
  stem_feedback += vec3(1.)-stem_feedback_mask;
	
  vec2 uv_left_arm_feedback = complex_mul((uv-pos2),vec2(cos2,sin2)*vec2(scale2)) + pos1;
  vec3 left_arm_feedback = bilinear( backbuffer, uv_left_arm_feedback).xyz + color_increment;
  vec3 left_arm_feedback_mask = vec3(square_mask(uv_left_arm_feedback));
  left_arm_feedback *= left_arm_feedback_mask;
  left_arm_feedback += vec3(1.)-left_arm_feedback_mask;
	
  vec2 uv_right_arm_feedback = complex_mul((uv-pos2),vec2(cos3,sin3)*vec2(scale2)) + pos1;
  vec3 right_arm_feedback = bilinear( backbuffer, uv_right_arm_feedback).xyz + color_increment;
  vec3 right_arm_feedback_mask = vec3(square_mask(uv_right_arm_feedback));
  right_arm_feedback *= right_arm_feedback_mask;
  right_arm_feedback += vec3(1.)-right_arm_feedback_mask;
	
  gl_FragColor.xyz = min( gl_FragColor.xyz, min(stem_feedback, min(left_arm_feedback, right_arm_feedback)));

  gl_FragColor.xyz = mix( gl_FragColor.xyz, texture2D(backbuffer, uv).xyz, vec3(0.2)); // sort of a motion blur
	
  gl_FragColor.a = 1.;
}