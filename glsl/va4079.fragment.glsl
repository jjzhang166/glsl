#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 viewer = vec3(0.0, 0.0, 1.0);
const vec3 diffuseColor = vec3(0.0, 0.5, 1.0);
const float diffusePower = .5;

void main( void ) {
	vec3 light = normalize(vec3(vec2(.5, .5)-mouse, 0.25));
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
 	float r = .5*sin(gl_FragCoord.x/resolution.x*100.0*sin(time*.25))*cos(gl_FragCoord.y/resolution.y*50.0);
 	vec2 diff2D = position-vec2(.5, .5);
	diff2D.x *= resolution.x/resolution.y;
 	if (length(diff2D) < r) {
		float z = sqrt(r*r - (diff2D.x*diff2D.x + diff2D.y*diff2D.y));
  		// 3d position: vec3 diff3D = vec3(diff2D, z);
		
		
		vec2 dz = -diff2D.xy/z;
		vec3 normal = normalize(vec3(dz, 1.0));
		
		float i = dot(light, normal);
 
                // CALCULATE THE DIFFUSE LIGHT FACTORING IN LIGHT COLOUR, POWER AND THE ATTENUATION
                vec3 diffuse = i * diffusePower * diffuseColor; 
 
                //CALCULATE THE HALF VECTOR BETWEEN THE LIGHT VECTOR AND THE VIEW VECTOR. THIS IS CHEAPER THAN CALCULATING THE ACTUAL REFLECTIVE VECTOR
                vec3 h = normalize(light + viewer);
 
                // INTENSITY OF THE SPECULAR LIGHT
                // DOT PRODUCT OF NORMAL VECTOR AND THE HALF VECTOR TO THE POWER OF THE SPECULAR HARDNESS
                i = pow(dot(normal, h), 8.0);
 
                // CALCULATE THE SPECULAR LIGHT FACTORING IN LIGHT SPECULAR COLOUR, POWER AND THE ATTENUATION
                vec3 specular = vec3(i, i, i); 
		
  		gl_FragColor = vec4(specular + diffuse, 1.0);
 	} else {
 		gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
 	}
}