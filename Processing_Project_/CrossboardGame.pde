// =============================================
//  CROSSBOARD GAME — Checkers in Processing
//  by Claude | How to run: open in Processing IDE
// =============================================

// --- Constants ---
final int COLS       = 8;
final int ROWS       = 8;
final int CELL       = 80;       // pixels per cell
final int BOARD_SIZE = COLS * CELL;

// Piece codes
final int EMPTY   = 0;
final int RED     = 1;   // player 1 (bottom)
final int BLACK   = 2;   // player 2 (top)
final int RED_K   = 3;   // red king
final int BLACK_K = 4;   // black king

// --- State ---
int[][] board = new int[ROWS][COLS];
int currentPlayer = RED;   // RED goes first
int selectedRow = -1;
int selectedCol = -1;
boolean gameOver = false;
String message   = "Red's turn";

// Valid moves for the selected piece (list of [toRow,toCol])
ArrayList<int[]> validMoves = new ArrayList<int[]>();

// -----------------------------------------------
void setup() {
  size(640, 700);
  textAlign(CENTER, CENTER);
  initBoard();
}

// -----------------------------------------------
void draw() {
  background(30);
  drawBoard();
  drawPieces();
  drawHighlights();
  drawUI();
}

// -----------------------------------------------
//  BOARD SETUP
// -----------------------------------------------
void initBoard() {
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      board[r][c] = EMPTY;
      // Black pieces on rows 0-2, dark squares only
      if (r < 3 && (r + c) % 2 == 1) board[r][c] = BLACK;
      // Red pieces on rows 5-7, dark squares only
      if (r > 4 && (r + c) % 2 == 1) board[r][c] = RED;
    }
  }
  currentPlayer = RED;
  message = "Red's turn";
  selectedRow = -1;
  selectedCol = -1;
  gameOver = false;
  validMoves.clear();
}

// -----------------------------------------------
//  DRAWING
// -----------------------------------------------
void drawBoard() {
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      if ((r + c) % 2 == 0) fill(240, 217, 181);   // light square
      else                    fill(100,  60,  20);  // dark square
      noStroke();
      rect(c * CELL, r * CELL, CELL, CELL);
    }
  }
  // Board border
  noFill();
  stroke(80);
  strokeWeight(3);
  rect(0, 0, BOARD_SIZE, BOARD_SIZE);
  strokeWeight(1);
}

void drawPieces() {
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      int p = board[r][c];
      if (p == EMPTY) continue;

      float cx = c * CELL + CELL / 2.0;
      float cy = r * CELL + CELL / 2.0;

      // Shadow
      fill(0, 0, 0, 80);
      noStroke();
      ellipse(cx + 3, cy + 4, CELL * 0.68, CELL * 0.68);

      // Piece body
      if (p == RED || p == RED_K) {
        fill(200, 40, 40);
        stroke(140, 20, 20);
      } else {
        fill(30, 30, 30);
        stroke(10, 10, 10);
      }
      strokeWeight(2);
      ellipse(cx, cy, CELL * 0.68, CELL * 0.68);

      // Highlight ring
      if (p == RED || p == RED_K) fill(230, 100, 100);
      else                          fill(80, 80, 80);
      noStroke();
      ellipse(cx - 6, cy - 7, CELL * 0.25, CELL * 0.18);

      // King crown
      if (p == RED_K || p == BLACK_K) {
        fill(255, 215, 0);
        noStroke();
        textSize(22);
        text("♛", cx, cy);
      }
    }
  }
  strokeWeight(1);
}

void drawHighlights() {
  // Selected piece — blue outline
  if (selectedRow >= 0) {
    noFill();
    stroke(80, 160, 255);
    strokeWeight(4);
    rect(selectedCol * CELL + 3, selectedRow * CELL + 3, CELL - 6, CELL - 6, 5);
    strokeWeight(1);
  }

  // Valid move targets — green dots
  for (int[] mv : validMoves) {
    float cx = mv[1] * CELL + CELL / 2.0;
    float cy = mv[0] * CELL + CELL / 2.0;
    noStroke();
    fill(80, 220, 100, 180);
    ellipse(cx, cy, CELL * 0.35, CELL * 0.35);
  }
}

void drawUI() {
  // Status bar below board
  fill(20);
  noStroke();
  rect(0, BOARD_SIZE, width, height - BOARD_SIZE);

  // Current player indicator
  if (!gameOver) {
    fill(currentPlayer == RED ? color(200, 40, 40) : color(200));
    ellipse(30, BOARD_SIZE + 30, 28, 28);
  }

  fill(240);
  textSize(18);
  text(message, width / 2, BOARD_SIZE + 30);

  // Restart hint
  fill(150);
  textSize(13);
  text("Press R to restart", width / 2, BOARD_SIZE + 58);
}

// -----------------------------------------------
//  INPUT
// -----------------------------------------------
void mousePressed() {
  if (gameOver) return;

  int col = mouseX / CELL;
  int row = mouseY / CELL;
  if (row >= ROWS || col >= COLS || row < 0 || col < 0) return;

  int clicked = board[row][col];

  // Click own piece → select it
  if (isCurrentPlayer(clicked)) {
    selectedRow = row;
    selectedCol = col;
    validMoves = getValidMoves(row, col);
    return;
  }

  // Click valid move destination → execute move
  if (selectedRow >= 0) {
    for (int[] mv : validMoves) {
      if (mv[0] == row && mv[1] == col) {
        executeMove(selectedRow, selectedCol, row, col);
        return;
      }
    }
  }

  // Click elsewhere → deselect
  selectedRow = -1;
  selectedCol = -1;
  validMoves.clear();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    initBoard();
  }
}

// -----------------------------------------------
//  GAME LOGIC
// -----------------------------------------------
boolean isCurrentPlayer(int piece) {
  if (currentPlayer == RED   && (piece == RED   || piece == RED_K))   return true;
  if (currentPlayer == BLACK && (piece == BLACK || piece == BLACK_K)) return true;
  return false;
}

boolean isOpponent(int piece) {
  if (currentPlayer == RED   && (piece == BLACK || piece == BLACK_K)) return true;
  if (currentPlayer == BLACK && (piece == RED   || piece == RED_K))   return true;
  return false;
}

// Returns list of valid move destinations [toRow, toCol] for piece at (r,c)
ArrayList<int[]> getValidMoves(int r, int c) {
  ArrayList<int[]> moves  = new ArrayList<int[]>();
  ArrayList<int[]> jumps  = new ArrayList<int[]>();
  int piece = board[r][c];
  boolean king = (piece == RED_K || piece == BLACK_K);

  // Directions: RED moves up (negative row), BLACK moves down (positive row)
  int[] dirs;
  if      (piece == RED)    dirs = new int[]{-1};
  else if (piece == BLACK)  dirs = new int[]{ 1};
  else                      dirs = new int[]{-1, 1};   // king both ways

  for (int dr : dirs) {
    for (int dc : new int[]{-1, 1}) {
      int nr = r + dr, nc = c + dc;
      if (!inBounds(nr, nc)) continue;

      if (board[nr][nc] == EMPTY) {
        // Simple step
        moves.add(new int[]{nr, nc});
      } else if (isOpponent(board[nr][nc])) {
        // Jump over opponent
        int jr = r + dr * 2, jc = c + dc * 2;
        if (inBounds(jr, jc) && board[jr][jc] == EMPTY) {
          jumps.add(new int[]{jr, jc});
        }
      }
    }
  }
  // Jumps take priority — if any exist return only jumps
  return jumps.size() > 0 ? jumps : moves;
}

void executeMove(int fr, int fc, int tr, int tc) {
  int piece = board[fr][fc];
  board[tr][tc] = piece;
  board[fr][fc] = EMPTY;

  // Capture (jump): remove the jumped piece
  if (abs(tr - fr) == 2) {
    int mr = (fr + tr) / 2;
    int mc = (fc + tc) / 2;
    board[mr][mc] = EMPTY;

    // Check multi-jump
    ArrayList<int[]> furtherJumps = getJumpsOnly(tr, tc);
    if (furtherJumps.size() > 0) {
      promoteIfKing(tr, tc);
      selectedRow = tr;
      selectedCol = tc;
      validMoves = furtherJumps;
      return;   // same player continues
    }
  }

  promoteIfKing(tr, tc);
  selectedRow = -1;
  selectedCol = -1;
  validMoves.clear();
  switchPlayer();
  checkWin();
}

ArrayList<int[]> getJumpsOnly(int r, int c) {
  ArrayList<int[]> jumps = new ArrayList<int[]>();
  int piece = board[r][c];
  boolean king = (piece == RED_K || piece == BLACK_K);
  int[] dirs;
  if      (piece == RED)   dirs = new int[]{-1};
  else if (piece == BLACK) dirs = new int[]{ 1};
  else                     dirs = new int[]{-1, 1};

  for (int dr : dirs) {
    for (int dc : new int[]{-1, 1}) {
      int nr = r + dr, nc = c + dc;
      if (!inBounds(nr, nc)) continue;
      if (isOpponent(board[nr][nc])) {
        int jr = r + dr * 2, jc = c + dc * 2;
        if (inBounds(jr, jc) && board[jr][jc] == EMPTY) {
          jumps.add(new int[]{jr, jc});
        }
      }
    }
  }
  return jumps;
}

void promoteIfKing(int r, int c) {
  if (board[r][c] == RED   && r == 0) board[r][c] = RED_K;
  if (board[r][c] == BLACK && r == ROWS - 1) board[r][c] = BLACK_K;
}

void switchPlayer() {
  currentPlayer = (currentPlayer == RED) ? BLACK : RED;
  message = (currentPlayer == RED) ? "Red's turn" : "Black's turn";
}

void checkWin() {
  int reds = 0, blacks = 0;
  for (int r = 0; r < ROWS; r++)
    for (int c = 0; c < COLS; c++) {
      if (board[r][c] == RED   || board[r][c] == RED_K)   reds++;
      if (board[r][c] == BLACK || board[r][c] == BLACK_K) blacks++;
    }

  if (reds == 0)   { message = "Black wins! 🎉"; gameOver = true; }
  if (blacks == 0) { message = "Red wins! 🎉";   gameOver = true; }
}

boolean inBounds(int r, int c) {
  return r >= 0 && r < ROWS && c >= 0 && c < COLS;
}
