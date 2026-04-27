// =============================================
//  CROSSBOARD GAME — Movement Conditions Added
// =============================================

int rows = 6, cols = 6;
int CELL = 100;                        // Each cell = 100px (600/6)

Board board;
int NSERP = 2, NSECP = 3;

Strikers[][] player1;
Strikers[][] player2;

// Grid lookup: which striker occupies each cell? null = empty
Strikers[][] grid = new Strikers[rows][cols];

color Red  = color(252, 0, 0);
color Blue = color(0, 124, 252);

// --- Turn & Selection ---
int      currentTurn     = 1;          // 1 = Red's turn, 2 = Blue's turn
Strikers selectedStriker = null;       // which piece is selected
ArrayList<int[]> validMoves = new ArrayList<int[]>();

String message = "Red's Turn";

// -----------------------------------------------
void setup() {
  noStroke();
  size(600, 640);                      // extra 40px for status bar
  board = new Board(6, 6);

  player1 = new Strikers[NSERP][NSECP];
  player2 = new Strikers[NSERP][NSECP];

  // --- Place Player 1 (Red) on top dark squares ---
  // Row 0: cols 0,2,4  |  Row 1: cols 1,3,5
  for (int r = 0; r < NSERP; r++) {
    for (int c = 0; c < NSECP; c++) {
      int gc = r % 2 == 0 ? c * 2 : c * 2 + 1;
      player1[r][c] = new Strikers(gc, r, Red, 1);
      grid[r][gc] = player1[r][c];
    }
  }

  // --- Place Player 2 (Blue) on bottom dark squares ---
  // Row 4: cols 0,2,4  |  Row 5: cols 1,3,5
  for (int r = 0; r < NSERP; r++) {
    int gr = rows - NSERP + r;
    for (int c = 0; c < NSECP; c++) {
      int gc = gr % 2 == 0 ? c * 2 : c * 2 + 1;
      player2[r][c] = new Strikers(gc, gr, Blue, 2);
      grid[gr][gc] = player2[r][c];
    }
  }
}

// -----------------------------------------------
void draw() {
  background(255);
  board.display();
  drawValidMoveSpots();
  drawAllStrikers();
  drawStatusBar();
}

// Draw green dots on valid move targets
void drawValidMoveSpots() {
  for (int[] mv : validMoves) {
    int gr = mv[0], gc = mv[1];
    noStroke();
    fill(0, 200, 80, 160);
    ellipse(gc * CELL + 50, gr * CELL + 50, 40, 40);
  }
}

void drawAllStrikers() {
  for (Strikers[] row : player1)
    for (Strikers s : row)
      if (s != null) s.display();

  for (Strikers[] row : player2)
    for (Strikers s : row)
      if (s != null) s.display();
}

void drawStatusBar() {
  fill(30);
  noStroke();
  rect(0, 600, 600, 40);

  textAlign(CENTER, CENTER);
  textSize(17);
  fill(currentTurn == 1 ? Red : Blue);
  ellipse(24, 620, 20, 20);

  fill(240);
  text(message, 300, 620);
}

// -----------------------------------------------
//  MOUSE INPUT
// -----------------------------------------------
void mousePressed() {
  if (mouseY >= 600) return;

  int gc = mouseX / CELL;
  int gr = mouseY / CELL;

  if (!inBounds(gr, gc)) return;

  Strikers clicked = grid[gr][gc];

  // Select own piece
  if (clicked != null && clicked.owner == currentTurn) {
    selectedStriker = clicked;
    validMoves = getValidMoves(clicked);
    return;
  }

  // Move to valid destination
  if (selectedStriker != null) {
    for (int[] mv : validMoves) {
      if (mv[0] == gr && mv[1] == gc) {
        executeMove(selectedStriker, gr, gc);
        return;
      }
    }
  }

  // Deselect
  selectedStriker = null;
  validMoves.clear();
}

// -----------------------------------------------
//  MOVEMENT CONDITIONS
// -----------------------------------------------
ArrayList<int[]> getValidMoves(Strikers s) {
  ArrayList<int[]> steps = new ArrayList<int[]>();
  ArrayList<int[]> jumps = new ArrayList<int[]>();

  // CONDITION 1: Direction of movement
  // Red  (owner 1) moves DOWN  (positive row)
  // Blue (owner 2) moves UP    (negative row)
  // Kings move BOTH directions
  int[] dirRows;
  if      (s.isKing)     dirRows = new int[]{-1, 1};
  else if (s.owner == 1) dirRows = new int[]{ 1};
  else                   dirRows = new int[]{-1};

  for (int dr : dirRows) {
    for (int dc : new int[]{-1, 1}) {       // diagonal left & right

      int nr = s.gridRow + dr;
      int nc = s.gridCol + dc;

      // CONDITION 2: Target must be inside the board
      if (!inBounds(nr, nc)) continue;

      // CONDITION 3: Can only land on dark squares (i+j) % 2 == 0
      if ((nr + nc) % 2 != 0) continue;

      if (grid[nr][nc] == null) {
        // CONDITION 4: Simple step — cell must be empty
        steps.add(new int[]{nr, nc});

      } else if (grid[nr][nc].owner != s.owner) {
        // CONDITION 5: Jump — diagonal neighbor is an opponent
        int jr = s.gridRow + dr * 2;
        int jc = s.gridCol + dc * 2;

        // CONDITION 6: Landing square must be in bounds AND empty
        if (inBounds(jr, jc) && grid[jr][jc] == null) {
          jumps.add(new int[]{jr, jc});
        }
      }
    }
  }

  // CONDITION 7: Jump priority — jumps override steps
  if (jumps.size() > 0) return jumps;
  return steps;
}

ArrayList<int[]> getJumpsOnly(Strikers s) {
  ArrayList<int[]> jumps = new ArrayList<int[]>();
  int[] dirRows = s.isKing ? new int[]{-1,1} : (s.owner==1 ? new int[]{1} : new int[]{-1});

  for (int dr : dirRows) {
    for (int dc : new int[]{-1, 1}) {
      int nr = s.gridRow + dr;
      int nc = s.gridCol + dc;
      if (!inBounds(nr, nc)) continue;
      if (grid[nr][nc] != null && grid[nr][nc].owner != s.owner) {
        int jr = s.gridRow + dr * 2;
        int jc = s.gridCol + dc * 2;
        if (inBounds(jr, jc) && grid[jr][jc] == null)
          jumps.add(new int[]{jr, jc});
      }
    }
  }
  return jumps;
}

// -----------------------------------------------
//  EXECUTE MOVE
// -----------------------------------------------
void executeMove(Strikers s, int toRow, int toCol) {
  int fromRow = s.gridRow;
  int fromCol = s.gridCol;

  grid[fromRow][fromCol] = null;
  grid[toRow][toCol]     = s;
  s.moveTo(toCol, toRow);

  // CONDITION 8: Capture — remove the jumped opponent
  boolean jumped = abs(toRow - fromRow) == 2;
  if (jumped) {
    int mr = (fromRow + toRow) / 2;
    int mc = (fromCol + toCol) / 2;
    removeStriker(grid[mr][mc]);
    grid[mr][mc] = null;

    // CONDITION 9: Multi-jump — if more jumps exist, same player continues
    ArrayList<int[]> furtherJumps = getJumpsOnly(s);
    if (furtherJumps.size() > 0) {
      selectedStriker = s;
      validMoves = furtherJumps;
      message = (currentTurn == 1 ? "Red" : "Blue") + " — keep jumping!";
      return;
    }
  }

  // CONDITION 10: King promotion — reach the opposite end
  if (s.owner == 1 && toRow == rows - 1) s.isKing = true;  // Red reaches bottom
  if (s.owner == 2 && toRow == 0)        s.isKing = true;  // Blue reaches top

  selectedStriker = null;
  validMoves.clear();
  if (!checkWin()) switchTurn();
}

// -----------------------------------------------
//  HELPERS
// -----------------------------------------------
boolean inBounds(int r, int c) {
  return r >= 0 && r < rows && c >= 0 && c < cols;
}

void removeStriker(Strikers s) {
  if (s == null) return;
  for (int r = 0; r < NSERP; r++) {
    for (int c = 0; c < NSECP; c++) {
      if (player1[r][c] == s) { player1[r][c] = null; return; }
      if (player2[r][c] == s) { player2[r][c] = null; return; }
    }
  }
}

void switchTurn() {
  currentTurn = (currentTurn == 1) ? 2 : 1;
  message = (currentTurn == 1) ? "Red's Turn" : "Blue's Turn";
}

boolean checkWin() {
  int r1 = 0, r2 = 0;
  for (int r = 0; r < rows; r++)
    for (int c = 0; c < cols; c++) {
      if (grid[r][c] != null && grid[r][c].owner == 1) r1++;
      if (grid[r][c] != null && grid[r][c].owner == 2) r2++;
    }
  if (r1 == 0) { message = "Blue Wins!  Press R to restart"; return true; }
  if (r2 == 0) { message = "Red Wins!   Press R to restart"; return true; }
  return false;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    grid = new Strikers[rows][cols];
    validMoves.clear();
    selectedStriker = null;
    currentTurn = 1;
    setup();
  }
}

// -----------------------------------------------
//  YOUR ORIGINAL CLASSES (gridRow/gridCol added)
// -----------------------------------------------

class Board {
  int rows, cols;
  Square[][] squares;

  Board(int r, int c) {
    rows = r; cols = c;
    squares = new Square[rows][cols];
    float w = 600.0 / cols;
    float h = 600.0 / rows;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        color fillCol = ((i + j) % 2 == 0) ? color(0) : color(206, 168, 148);
        squares[i][j] = new Square(j * w, i * h, w, h, fillCol);
      }
    }
  }

  void display() {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < cols; j++)
        squares[i][j].render();
  }
}

class Square {
  float x, y, w, h;
  color c;

  Square(float x_, float y_, float w_, float h_, color c_) {
    x = x_; y = y_; w = w_; h = h_; c = c_;
  }

  void render() {
    fill(c);
    noStroke();
    rect(x, y, w, h);
  }
}

class Strikers {
  color   col;
  int     gridCol, gridRow;    // grid position
  int     owner;               // 1 = Red, 2 = Blue
  boolean isKing = false;

  Strikers(int gc, int gr, color paint, int own) {
    col     = paint;
    gridCol = gc;
    gridRow = gr;
    owner   = own;
  }

  void moveTo(int gc, int gr) {
    gridCol = gc;
    gridRow = gr;
  }

  void display() {
    float cx = gridCol * CELL + 50;
    float cy = gridRow * CELL + 50;

    // Yellow glow when selected
    if (this == selectedStriker) {
      noStroke();
      fill(255, 230, 0, 160);
      ellipse(cx, cy, 96, 96);
    }

    // Shadow
    fill(0, 0, 0, 70);
    noStroke();
    ellipse(cx + 3, cy + 4, 80, 80);

    // Piece body
    fill(col);
    noStroke();
    ellipse(cx, cy, 80, 80);

    // Shine
    fill(255, 255, 255, 80);
    ellipse(cx - 10, cy - 12, 26, 18);

    // King crown
    if (isKing) {
      fill(255, 215, 0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("K", cx, cy);
    }
  }
}
