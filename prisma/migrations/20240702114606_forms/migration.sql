/*
  Warnings:

  - Added the required column `adress` to the `Forms` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Forms" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "adress" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "image" TEXT
);
INSERT INTO "new_Forms" ("desc", "id", "image", "status", "title", "user_id") SELECT "desc", "id", "image", "status", "title", "user_id" FROM "Forms";
DROP TABLE "Forms";
ALTER TABLE "new_Forms" RENAME TO "Forms";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
