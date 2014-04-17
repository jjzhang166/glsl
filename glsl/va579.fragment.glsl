precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// @danbri learnings
float r,g,b = 0.3;

void main( void ) {
  vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  if (2.*position.y > .7) { g += 0.55; }
  if ((position.x / position.y) < sin(time)) { r = 0.75; }
  if ((position.y) > tan(time)) { r *= 0.35; }
  if ((position.x) > .5 * sin(time)) { b *= 0.25;}
  if ((position.y-position.x) > .4 * cos(time)) { g *= 0.95;}
  if ((position.x * position.y) > .75 * sin(time)) { r = 0.95;}
  if ((position.y) > .25 * sin(3. * time)) { b = 0.85;}

  if (position.x * position.x  > cos(time * 1.2) ) { r = 0.; g = .0; b = .0; } 
gl_FragColor = vec4( vec3( r,g,b), 1.0 );
}

