#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;


void main() {
  vec2 p = vec2(gl_FragCoord.x - 200.0, gl_FragCoord.y) / resolution.xy;
  vec2 q = p;

  bool diverged = false;
	float w = 0.0;
  for (int i = 0; i < 6; ++i) {
	  
	  float qm = length(q);
	  float ox = pow(q.x, 0.5);
	  float oy = pow(q.y, 0.5);
    q = vec2(ox - oy, 5.0 * q.x * oy );
	q += p*4.0;  
	  w = (q.x * q.x + q.y * q.y)-50.0;
	  w*=0.01;
    if (q.x * q.x + q.y * q.y > 50.0) {
      diverged = true;
	    
      break;
    }
  }

	float gx = q.x+10.0;
  if (diverged)
    gl_FragColor = vec4(w*0.5, w*q.y*0.02, w*gx*0.01, 1);
  else
    gl_FragColor = vec4(0, 0, 0, 1);
}