#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

 const float radius_0 = 200.0;
 const float radius_1 = 500.0;
 
 void main ()
 {
     highp float dr = radius_1 - radius_0;
     highp float dot_circle_1_pos = dot(mouse, mouse);
     highp float dot_pos_circle_1_pos = dot(gl_FragCoord.xy, mouse);
     
     highp float A = dot_circle_1_pos - dr * dr;
     highp float B = -2.0 * (dot_pos_circle_1_pos + radius_0 * dr);
     highp float C = dot(gl_FragCoord.xy, gl_FragCoord.xy) - radius_0 * radius_0;
     highp float det = B * B - 4.0 * A * C;
     det = max(det, 0.0);
     
     highp float sqrt_det = sqrt(det);
     // This complicated bit of logic acts as \if (A < 0.0) sqrt_det = -sqrt_det,
     // without the branch.
     sqrt_det *= 1.0 + 2.0 * sign(min(A, 0.0));
     
     highp float t = (-B + sqrt_det) / (2.0 * A);
     gl_FragColor = mix(vec4(1,0,0,1), vec4(0,0,0,1), t); 
 }
	 